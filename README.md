# 🛠️ Automated Sequence and Trigger Generator for Numeric Primary Keys in Oracle

---

## 🔍 Project Overview

This PL/SQL script streamlines primary key management by **automatically creating sequences and triggers** for all tables in your Oracle schema that have a **single numeric primary key column**.

Managing sequences and triggers manually can be error-prone and time-consuming. This automation ensures:

- Sequences start from the correct next available value.
- Triggers assign sequence values before insert, guaranteeing unique, incremental primary keys.
- Existing sequences are safely dropped and recreated for consistency.

This tool is ideal for database administrators and developers who want to maintain data integrity effortlessly.

---

## 🛠️ How It Works

### Core Functionality

1. **Drops all existing sequences** in your schema to avoid conflicts.
2. **Identifies tables** with exactly one primary key column of type `NUMBER`.
3. For each such table:
   - Calculates the next primary key value (`MAX + 1`) dynamically.
   - Creates a new sequence starting at this value.
   - Creates a `BEFORE INSERT` trigger that assigns the sequence’s next value to the primary key column.

### Naming Conventions

| Object Type | Naming Pattern               |
|-------------|-----------------------------|
| Sequence    | `<TABLE_NAME>_SEQ`           |
| Trigger     | `<TABLE_NAME>_TRIG`          |

---

## ⚡ Usage Instructions

### 1. Enable DBMS Output

Ensure your SQL client shows output messages to monitor progress:

```sql
SET SERVEROUTPUT ON SIZE 1000000;
```
## Testing Video : 
- https://drive.google.com/file/d/11FgwqeSMux-ow8xfXbTlS7m_tJD4M7Ug/view?usp=sharing
