#!/bin/bash

# OpenNova Oracle Cloud Setup Script
# Run this on your Oracle Cloud VM

echo "🚀 Starting OpenNova Setup..."

# Update system
echo "📦 Updating system..."
sudo apt update && sudo apt upgrade -y

# Install required software
echo "🔧 Installing Java, PostgreSQL, Nginx..."
sudo apt install openjdk-17-jdk postgresql postgresql-contrib nginx git -y

# Start and enable PostgreSQL
echo "🗄️ Configuring PostgreSQL..."
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Create database and user
echo "📊 Setting up database..."
sudo -u postgres psql -c "CREATE DATABASE opennova;"
sudo -u postgres psql -c "CREATE USER opennova WITH PASSWORD 'abi@1234';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE opennova TO opennova;"

# Create application directory
echo "📁 Creating application directory..."
mkdir -p /home/ubuntu/opennova
cd /home/ubuntu/opennova

# Create application.properties
echo "⚙️ Creating application configuration..."
cat > /home/ubuntu/opennova/application.properties << 'EOF'
# Database Configuration
spring.datasource.url=jdbc:postgresql://localhost:5432/opennova
spring.datasource.username=opennova
spring.datasource.password=abi@1234
spring.datasource.driver-class-name=org.postgresql.Driver

# JPA/Hibernate
spring.jpa.hibernate.ddl-auto=validate
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
spring.jpa.show-sql=false

# Server Configuration
server.port=8080
server.servlet.context-path=/

# Logging
logging.level.com.opennova=INFO
logging.level.org.springframework.web=INFO
logging.file.name=/home/ubuntu/opennova/opennova.log

# Flyway Migration
spring.flyway.enabled=true
spring.flyway.baseline-on-migrate=true

# Security
spring.security.basic.enabled=false
EOF

# Create systemd service
echo "🔧 Creating systemd service..."
sudo tee /etc/systemd/system/opennova.service > /dev/null << 'EOF'
[Unit]
Description=OpenNova Spring Boot Application
After=network.target postgresql.service

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu/opennova
ExecStart=/usr/bin/java -Xmx2g -jar backend-0.0.1-SNAPSHOT.jar --spring.config.location=file:./application.properties
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Configure Nginx
echo "🌐 Configuring Nginx..."
sudo tee /etc/nginx/sites-available/opennova > /dev/null << 'EOF'
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

# Enable Nginx site
sudo rm -f /etc/nginx/sites-enabled/default
sudo ln -sf /etc/nginx/sites-available/opennova /etc/nginx/sites-enabled/

# Configure firewall
echo "🔥 Configuring firewall..."
sudo ufw allow ssh
sudo ufw allow 'Nginx Full'
sudo ufw --force enable

# Set permissions
echo "🔐 Setting permissions..."
sudo chown -R ubuntu:ubuntu /home/ubuntu/opennova

echo "✅ Setup complete! Now upload your JAR file to /home/ubuntu/opennova/"
echo "📁 Upload command: scp backend/target/backend-0.0.1-SNAPSHOT.jar ubuntu@YOUR_VM_IP:/home/ubuntu/opennova/"
echo "🚀 Start command: sudo systemctl enable opennova && sudo systemctl start opennova" 