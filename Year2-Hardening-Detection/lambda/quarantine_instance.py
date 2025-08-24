import os, json, boto3
ec2 = boto3.client("ec2")
ACTION = os.getenv("ACTION", "stop")
MATCH_TYPES = {"UnauthorizedAccess:EC2/SSHBruteForce","CryptoCurrency:EC2/BitcoinTool.B!DNS","Backdoor:EC2/DenialOfService"}

def lambda_handler(event, context):
    detail = event.get("detail", {})
    finding = detail.get("findings", [{}])[0] if "findings" in detail else detail
    ftype = finding.get("type") or finding.get("Type")
    sev = finding.get("severity") or finding.get("Severity", 0)
    res = finding.get("resource", finding.get("Resource", {}))
    inst = res.get("instanceDetails", res.get("InstanceDetails", {}))
    instance_id = inst.get("instanceId") or inst.get("InstanceId")
    if not instance_id: return {"status":"no_instance"}
    if ACTION == "stop" and (ftype in MATCH_TYPES or float(sev) >= 5.0):
        ec2.stop_instances(InstanceIds=[instance_id])
        return {"status":"stopped","instance":instance_id}
    return {"status":"no_action"}
