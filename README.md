# Infrastructure as Code: 3-Tier Web Application on AWS

This project demonstrates a complete, automated, and repeatable pipeline for deploying a production-grade three-tier web application on Amazon Web Services (AWS). It leverages modern Infrastructure as Code (IaC) and configuration management tools to separate the application into a Presentation Layer (Frontend), an Application Layer (Backend), and a Data Layer (Database)

---

## 🛠️ Tools & Technologies

*   **Terraform:** An open-source tool by HashiCorp used to provision the cloud infrastructure declaratively. It communicates with the AWS API and maintains a state file tracking the real-world status of managed resources.
*   **Ansible:** An open-source automation tool by Red Hat used to configure the servers provisioned by Terraform.
*   **HashiCorp Vault:** An open-source secrets management tool used to securely store and dynamically inject AWS credentials. This ensures zero hardcoded secrets are written to disk or committed to version control.
*   **AWS Services:** VPC, EC2, Application Load Balancers, Auto Scaling Groups, NAT Gateway, and Internet Gateway.
*   **Application Stack:** Nginx (Frontend), Node.js managed by PM2 (Backend), and MongoDB 7.0 (Database). 

---

## 🏗️ Architecture Details

### Network Infrastructure
*   The architecture is isolated within a custom Virtual Private Cloud (VPC) using the CIDR block `10.0.0.0/16`.
*   The VPC contains two Public Subnets and two Private Subnets, spanning two Availability Zones (`us-east-1a` and `us-east-1b`) for high availability.
*   An Internet Gateway provides outbound access for public subnets.
*   A NAT Gateway is placed in the public subnet to allow private instances to reach the internet for package installation without being directly reachable from the outside.

### Load Balancing
*   **External ALB:** An Application Load Balancer sitting in the public subnets acts as the single entry point for internet traffic, forwarding requests on port 80 to the Frontend instances.
*   **Internal ALB:** An internal load balancer sits in the private subnets to securely route API requests from the Frontend tier to the Backend tier on port 3000.

### Compute Layer
The compute layer utilizes eight `t2.micro` EC2 instances across four logical groups:
*   **Bastion Host (1 instance):** Placed in a public subnet to serve as the single, hardened SSH entry point into the VPC.
*   **Frontend ASG (2 to 4 instances):** An Auto Scaling Group deployed in private subnets, running Nginx to serve the user-facing interface.
*   **Backend ASG (2 to 4 instances):** An Auto Scaling Group in private subnets running Node.js APIs managed by PM2.
*   **Database Tier (3 instances):** Three instances distributed across private subnets, configured as a MongoDB Replica Set named `rs0` for high-availability data persistence.

### Security Groups
Traffic is strictly controlled using the principle of least privilege across six distinct Security Groups:
*   `novolt-bastion-sg`: Allows SSH (port 22) from the internet.
*   `novolt-ext-alb-sg`: Allows HTTP/HTTPS (port 80) from the internet.
*   `novolt-frontend-sg`: Accepts HTTP traffic only from the External ALB and SSH from the Bastion.
*   `novolt-int-alb-sg`: Accepts traffic only from the Frontend Security Group.
*   `novolt-backend-sg`: Accepts traffic on port 3000 only from the Internal ALB and SSH from the Bastion.
*   `novolt-db-sg`: Accepts MongoDB connections (port 27017) exclusively from the Backend Security Group and itself (for replication).

---

## ⚙️ Configuration Management

Ansible is responsible for the configuration layer, relying on automated discovery and secure tunneling:
*   **Dynamic Inventory:** The `amazon.aws.aws_ec2` plugin queries the AWS API at runtime to build a live inventory of running instances based on their EC2 tags.
*   **Secure Tunnelling:** Ansible connects to instances in private subnets by tunneling SSH traffic through the Bastion Host using a configured `ProxyCommand`.
*   **Application Deployment:** The "Novolt waitlist" application code is cloned dynamically from its GitHub repository (`https://github.com/OmarAlaaEl-Din/novolt-waitlist.git`) onto the frontend and backend servers. The MongoDB connection string is injected dynamically into the backend `.env` file without hard-coded IP addresses.


## 📁 Project Documentation
📄 **[View Full Project PDF](./Project.pdf)**
