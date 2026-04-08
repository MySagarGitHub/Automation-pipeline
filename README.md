# Automated Infrastructure Provisioning & Configuration Pipeline

## 🚀 Project Overview
This project is a fully automated DevOps pipeline that provisions AWS cloud infrastructure using Terraform, dynamically generates an inventory, and configures those instances as web servers using Ansible. Everything is orchestrated using a single Bash script for a "zero-click" deployment.

## 💻 Commands Used & Why

The core logic of this project relies on executing specific infrastructure commands in a sequence. Below is a summary of the exact commands used in this pipeline and the purpose behind each one:

### 1. Terraform Initialization
```bash
terraform init
```
**Why:** Downloads AWS provider plugins and initializes the working directory containing the Terraform configuration files so that Terraform can establish a connection with the cloud provider.

### 2. Infrastructure Provisioning
```bash
terraform apply -auto-approve
```
**Why:** Executes the deployment, building the declared AWS resources (EC2 instances, Security Groups, Key Pairs). The `-auto-approve` flag skips the manual "yes" prompt, allowing it to run fully automated in our shell script.

### 3. State Extraction
```bash
terraform output -json instance_public_ips > output.json
```
**Why:** Cloud IP addresses are dynamically assigned. This command extracts the public IPs of our newly created EC2 instances from the Terraform state and saves them locally as a formatted JSON file.

### 4. Dynamic Inventory Generation
```bash
python3 scripts/generate_inv.py
```
**Why:** Ansible requires an inventory file to know which servers to connect to. This custom Python script reads the freshly generated `output.json` and automatically formats it into an `.ini` inventory file that Ansible can understand, effectively bridging Terraform and Ansible.

### 5. Deployment Pause
```bash
sleep 15
```
**Why:** EC2 instances take a few moments to fully boot up and start their SSH daemon. This command pauses the script to ensure the servers are actually ready to accept Ansible's incoming SSH connections.

### 6. Configuration Management
```bash
ansible-playbook playbook.yml
```
**Why:** Executes the Ansible playbook against the dynamically generated target inventory. This logs into every server and applies the `webserver` role, configuring them uniformly without any manual setup.

### 7. Full Workflow Execution
```bash
./deploy.sh
```
**Why:** This is the master orchestration script that chains all of the above commands together sequentially, turning a complex manual process into a single executable command.

