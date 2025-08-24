locals { name = "${var.project}-baseline" }

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "${local.name}-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "${local.name}-igw" }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public" {
  for_each                = { for idx, cidr in var.public_subnet_cidrs : idx => cidr }
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = data.aws_availability_zones.available.names[tonumber(each.key)]
  map_public_ip_on_launch = true
  tags = { Name = "${local.name}-public-${each.key}" }
}

resource "aws_subnet" "private" {
  for_each          = { for idx, cidr in var.private_subnet_cidrs : idx => cidr }
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = data.aws_availability_zones.available.names[tonumber(each.key)]
  tags = { Name = "${local.name}-private-${each.key}" }
}

resource "aws_eip" "nat" {
  vpc = true
  tags = { Name = "${local.name}-nat-eip" }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = values(aws_subnet.public)[0].id
  tags = { Name = "${local.name}-nat" }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route { cidr_block = "0.0.0.0/0" , gateway_id = aws_internet_gateway.igw.id }
  tags = { Name = "${local.name}-public-rt" }
}

resource "aws_route_table_association" "public_assoc" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route { cidr_block = "0.0.0.0/0" , nat_gateway_id = aws_nat_gateway.nat.id }
  tags = { Name = "${local.name}-private-rt" }
}

resource "aws_route_table_association" "private_assoc" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "alb_sg" {
  name        = "${local.name}-alb-sg"
  description = "Allow HTTP from allowed CIDR"
  vpc_id      = aws_vpc.main.id
  ingress { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = [var.allowed_ingress_cidr] }
  egress  { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
  tags = { Name = "${local.name}-alb-sg" }
}

resource "aws_security_group" "app_sg" {
  name        = "${local.name}-app-sg"
  description = "Allow app traffic from ALB"
  vpc_id      = aws_vpc.main.id
  ingress { from_port = 80, to_port = 80, protocol = "tcp", security_groups = [aws_security_group.alb_sg.id] }
  egress  { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
  tags = { Name = "${local.name}-app-sg" }
}

resource "aws_iam_role" "ec2_ssm_role" {
  name = "${local.name}-ec2-ssm-role"
  assume_role_policy = jsonencode({ Version = "2012-10-17", Statement = [{
    Action = "sts:AssumeRole", Effect = "Allow", Principal = { Service = "ec2.amazonaws.com" } }] })
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_ssm_profile" {
  name = "${local.name}-ec2-ssm-profile"
  role = aws_iam_role.ec2_ssm_role.name
}

data "aws_ami" "amzn2" {
  owners      = ["137112412989"]
  most_recent = true
  filter { name = "name", values = ["amzn2-ami-hvm-*-x86_64-gp2"] }
}

resource "aws_instance" "app" {
  ami                    = data.aws_ami.amzn2.id
  instance_type          = var.instance_type
  subnet_id              = values(aws_subnet.private)[0].id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_ssm_profile.name
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    amazon-linux-extras install nginx1 -y || yum install -y nginx
    echo "<h1>${local.name} — App Tier</h1>" > /usr/share/nginx/html/index.html
    systemctl enable nginx
    systemctl start nginx
  EOF
  tags = { Name = "${local.name}-app-ec2" }
}

resource "aws_lb" "alb" {
  name               = "${var.project}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [for s in aws_subnet.public : s.id]
  dynamic "access_logs" {
    for_each = var.enable_alb_access_logs ? [1] : []
    content { bucket = var.alb_logs_bucket, enabled = true }
  }
  tags = { Name = "${local.name}-alb" }
}

resource "aws_lb_target_group" "tg" {
  name     = "${var.project}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  health_check { path = "/", matcher = "200-399", healthy_threshold = 2, unhealthy_threshold = 3, interval = 30, timeout = 5 }
  tags = { Name = "${local.name}-tg" }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port = 80
  protocol = "HTTP"
  default_action { type = "forward", target_group_arn = aws_lb_target_group.tg.arn }
}

resource "aws_lb_target_group_attachment" "app_attach" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.app.id
  port             = 80
}

resource "aws_cloudwatch_log_group" "flowlogs" {
  name              = "/aws/vpc/${var.project}/flowlogs"
  retention_in_days = 30
  tags = { Name = "${local.name}-flowlogs" }
}

resource "aws_iam_role" "vpc_flowlogs" {
  name = "${local.name}-vpc-flowlogs-role"
  assume_role_policy = jsonencode({ Version = "2012-10-17", Statement = [{
    Effect = "Allow", Principal = { Service = "vpc-flow-logs.amazonaws.com" }, Action = "sts:AssumeRole" }] })
}

resource "aws_iam_role_policy" "vpc_flowlogs" {
  name = "${local.name}-vpc-flowlogs-policy"
  role = aws_iam_role.vpc_flowlogs.id
  policy = jsonencode({ Version = "2012-10-17", Statement = [{
    Effect = "Allow", Action = [
      "logs:CreateLogGroup","logs:CreateLogStream","logs:PutLogEvents",
      "logs:DescribeLogGroups","logs:DescribeLogStreams"
    ], Resource = ["${"arn:aws:logs:*:*:log-group:/aws/vpc/*"}"] }] })
}

resource "aws_flow_log" "vpc" {
  log_destination_type = "cloud-watch-logs"
  log_group_name       = aws_cloudwatch_log_group.flowlogs.name
  iam_role_arn         = aws_iam_role.vpc_flowlogs.arn
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.main.id
  tags = { Name = "${local.name}-vpc-flow-logs" }
}
