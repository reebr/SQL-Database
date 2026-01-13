import mysql.connector
from faker import Faker
import random
from datetime import datetime, timedelta

# 1. إعدادات الاتصال بقاعدة البيانات
DB_HOST = "localhost"
DB_USER = "root"      
DB_PASSWORD = "1234566@Ma" 
DB_NAME = "ADBMS_Project" 

DEVICE_IDS = [1, 2, 3] 
NUM_READINGS_PER_DEVICE = 1000 

def generate_iot_data():

    try:
        conn = mysql.connector.connect(
            host=DB_HOST,
            user=DB_USER,
            password=DB_PASSWORD,
            database=DB_NAME
        )
        cursor = conn.cursor()
        print("✅ تم الاتصال بنجاح بقاعدة البيانات.")

    except mysql.connector.Error as err:
        print(f"❌ خطأ في الاتصال بقاعدة البيانات: {err}")
        return
    
    fake = Faker()

    try:
        print("⏳ تحديث جدول SMART_DEVICE ببيانات MAC Address...")
        mac_addresses = [fake.mac_address() for _ in DEVICE_IDS]
        for i, device_id in enumerate(DEVICE_IDS):
            update_query = "UPDATE SMART_DEVICE SET MAC_Address = %s WHERE Device_ID = %s"
            cursor.execute(update_query, (mac_addresses[i], device_id))
        conn.commit()
        print("✅ تم تحديث MAC Address بنجاح.")
    except Exception as e:
         print(f"❌ فشل تحديث MAC Address: {e}")
         conn.rollback()

    end_time = datetime.now()
    start_time = end_time - timedelta(days=30)
    
    print(f"⏳ بدء توليد وإدخال {NUM_READINGS_PER_DEVICE * len(DEVICE_IDS)} قراءة...")
    
    total_inserted = 0
    insert_query = """
    INSERT INTO CONSUMPTION_READING 
    (Device_ID, Reading_Timestamp, Consumption_kWh, Current_A) 
    VALUES (%s, %s, %s, %s)
    """

    for device_id in DEVICE_IDS:
        for _ in range(NUM_READINGS_PER_DEVICE):
            
            # توليد وقت عشوائي ضمن النطاق المحدد
            random_seconds = random.randint(0, int((end_time - start_time).total_seconds()))
            timestamp = start_time + timedelta(seconds=random_seconds)

            # توليد استهلاك عشوائي (يجب أن يكون الاستهلاك منطقياً لنوع الجهاز)
            if device_id == 1: # Central AC Unit: استهلاك عالي
                consumption_kwh = round(random.uniform(1.0, 5.5), 4) 
                current_a = round(random.uniform(5.0, 20.0), 4)
            elif device_id == 2: # Water Heater: استهلاك متوسط/متقطع
                consumption_kwh = round(random.uniform(0.5, 3.0), 4)
                current_a = round(random.uniform(2.0, 15.0), 4)
            else: # Smart Fridge: استهلاك منخفض/ثابت
                consumption_kwh = round(random.uniform(0.1, 1.0), 4)
                current_a = round(random.uniform(0.5, 5.0), 4)
                
            data = (device_id, timestamp, consumption_kwh, current_a)
            
            try:
                cursor.execute(insert_query, data)
                total_inserted += 1
            except mysql.connector.Error as e:
                # هذا قد يحدث إذا تكررت القراءة لنفس الجهاز بنفس اللحظة (UNIQUE Key)
                # يمكن تجاهل هذا الخطأ والاستمرار في التوليد
                pass 
                
    conn.commit()
    
    print(f"✅ اكتمل التوليد. تم إدخال {total_inserted} قراءة استهلاك بنجاح!")
    cursor.close()
    conn.close()

if __name__ == "__main__":
    generate_iot_data()