# ⚡ Smart Home Energy Management System

This project presents the design and implementation of a **Smart Home Energy Management System** focusing on
**database modeling, SQL schema design, data generation, and advanced querying**.

The system tracks users, houses, smart devices, energy consumption readings, tariffs, and command execution logs,
providing a structured foundation for analyzing energy usage and tariff application.

---

## 📌 Project Overview

The main goal of this project is to:
- Design a **normalized relational database**
- Model real-world smart home energy scenarios
- Implement SQL tables, relationships, transactions, and queries
- Support future analytics and optimization use cases

---

## 🗂️ System Components

The database models the following core entities:

- **USER** — system users and homeowners  
- **HOUSE** — physical houses owned by users  
- **SMART_DEVICE** — IoT devices installed in houses  
- **CONSUMPTION_READING** — electricity usage readings from devices  
- **TARIFF** — electricity pricing plans  
- **APPLIED_TARIFF** — tariffs applied to houses over time  
- **COMMAND_LOG** — commands issued by users to devices  

---

## 🧩 ER Diagram

The Entity-Relationship diagram illustrates:
- Ownership relationships between users and houses
- Device containment within houses
- Energy consumption readings per device
- Tariff definition and application periods
- User-device interaction through command execution

📷 Diagram files:
- `ERfinnel.drawio copy.png`
- `Class Diagram.drawio.png`

---

## 📁 Repository Structure

```text
SmartHomeEnergyDB/
├── ERfinnel.drawio copy.png        # Final ER diagram
├── Class Diagram.drawio.png        # System/Class diagram
├── CREATE TABLES.sql               # SQL schema and table creation
├── TRANSACTION.sql                 # Transaction management scripts
├── ADVANCED QUERY.sql              # Advanced SQL queries
├── generate_data.py                # Synthetic data generation script
└── README.md
