#
set -e  

echo "🚀 Running Terraform Apply..."
cd terra-config
terraform init
terraform apply -auto-approve

terraform output -json instance_public_ips > output.json


echo -e "\n📄 Generating Ansible Inventory..."
cd ..
python3 scripts/generate_inv.py

echo -e "\n Sleeping for 15 seconds for Instance Status Check"
sleep 15

echo -e "\n🧩 Running Ansible Playbook..."
cd ansible/
ansible-playbook playbook.yml


echo -e "\n✅ Deployment complete!"
