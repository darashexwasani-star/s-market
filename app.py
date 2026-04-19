from flask import Flask, render_template_string, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

all_posts = []

HTML_TEMPLATE = r"""
<!DOCTYPE html>
<html lang="ku" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>S-MARKET | SLIDE PRO</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Vazirmatn:wght@400;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
    <style>
        body { font-family: 'Vazirmatn', sans-serif; background: #f4f6f8; margin: 0; overflow-x: hidden; }
        .ocean-layer { position: relative; background: linear-gradient(180deg, #0f172a 0%, #1e40af 100%); height: 220px; z-index: 50; overflow: hidden; }
        .waves-container { position: absolute; bottom: -5px; width: 100%; height: 90px; }
        .parallax > use { animation: move-forever 20s cubic-bezier(.55,.5,.45,.5) infinite; }
        .parallax > use:nth-child(1) { animation-delay: -2s; fill: rgba(255,255,255,0.1); }
        .parallax > use:nth-child(2) { animation-delay: -3s; fill: rgba(255,255,255,0.2); }
        .parallax > use:nth-child(3) { animation-delay: -4s; fill: rgba(255,255,255,0.05); }
        .parallax > use:nth-child(4) { fill: #f4f6f8; }
        @keyframes move-forever { 0% { transform: translate3d(-90px, 0, 0); } 100% { transform: translate3d(85px, 0, 0); } }
        .glass-modal { background: rgba(255, 255, 255, 0.9); backdrop-filter: blur(20px); border-radius: 30px; }
        .card { background: white; border-radius: 25px; border: 1px solid #f1f5f9; overflow: hidden; transition: 0.3s; }
        .cat-chip { padding: 10px 22px; border-radius: 15px; background: white; color: #64748b; font-weight: 900; border: 1px solid #e2e8f0; transition: 0.3s; white-space: nowrap; }
        .cat-chip.active { background: #1e40af; color: white; border-color: #1e40af; }
        .no-scrollbar::-webkit-scrollbar { display: none; }
        .swiper { width: 100%; height: 320px; }
        .swiper-slide img { width: 100%; height: 100%; object-fit: cover; }
        .swiper-pagination-bullet { background: #fff !important; opacity: 0.7; }
        .swiper-pagination-bullet-active { background: #1e40af !important; width: 12px; height: 12px; opacity: 1; }
    </style>
</head>
<body>
    <div class="ocean-layer">
        <div class="relative z-[60] p-6">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-3xl font-black text-white tracking-tighter">S-MARKET</h1>
                <div class="flex gap-2 bg-white/10 p-1.5 rounded-2xl backdrop-blur-md">
                    <button onclick="setLanguage('sorani')" id="btn-sorani" class="px-4 py-1.5 rounded-xl text-[11px] font-bold">سۆرانی</button>
                    <button onclick="setLanguage('badini')" id="btn-badini" class="px-4 py-1.5 rounded-xl text-[11px] font-bold text-white/40">بادینی</button>
                </div>
            </div>
            <div class="flex gap-3">
                <input type="text" id="searchInp" onkeyup="renderData()" class="flex-1 px-5 py-4 bg-white/10 border border-white/20 rounded-2xl outline-none text-white placeholder-white/50 font-bold text-sm backdrop-blur-sm">
                <button onclick="toggleModal(true)" id="ui-add-btn" class="bg-white text-blue-900 px-6 py-4 rounded-2xl text-[12px] font-black shadow-2xl active:scale-95 transition-all"></button>
            </div>
        </div>
        <svg class="waves-container" xmlns="http://www.w3.org/2000/svg" viewBox="0 24 150 28" preserveAspectRatio="none">
            <defs><path id="wave-path" d="M-160 44c30 0 58-18 88-18s 58 18 88 18 58-18 88-18 58 18 88 18 v44h-352z" /></defs>
            <g class="parallax">
                <use xlink:href="#wave-path" x="48" y="0" /><use xlink:href="#wave-path" x="48" y="3" /><use xlink:href="#wave-path" x="48" y="5" /><use xlink:href="#wave-path" x="48" y="7" />
            </g>
        </svg>
    </div>
    <div id="catList" class="flex gap-3 overflow-x-auto no-scrollbar px-6 py-8"></div>
    <main class="px-6 pb-32"><div id="grid" class="grid grid-cols-2 md:grid-cols-4 gap-6"></div></main>
    <div id="modal" class="fixed inset-0 bg-black/30 hidden items-center justify-center p-6 z-[100] backdrop-blur-sm">
        <div class="glass-modal w-full max-w-sm p-8 max-h-[90vh] overflow-y-auto shadow-2xl">
            <h2 id="ui-title" class="text-2xl font-black mb-8 text-slate-800 text-center"></h2>
            <div class="space-y-4">
                <select id="pCat" class="w-full p-4 bg-slate-50 rounded-xl font-bold outline-none border border-slate-100"></select>
                <div class="grid grid-cols-3 gap-2">
                    <div onclick="document.getElementById('fInp1').click()" class="h-24 bg-slate-50 rounded-xl border-2 border-dashed flex items-center justify-center cursor-pointer overflow-hidden">
                        <img id="pImg1" class="w-full h-full object-cover hidden">
                        <span id="pTxt1" class="text-[10px] text-slate-400 font-bold">وێنە ١</span>
                    </div>
                    <div onclick="document.getElementById('fInp2').click()" class="h-24 bg-slate-50 rounded-xl border-2 border-dashed flex items-center justify-center cursor-pointer overflow-hidden">
                        <img id="pImg2" class="w-full h-full object-cover hidden">
                        <span id="pTxt2" class="text-[10px] text-slate-400 font-bold">وێنە ٢</span>
                    </div>
                    <div onclick="document.getElementById('fInp3').click()" class="h-24 bg-slate-50 rounded-xl border-2 border-dashed flex items-center justify-center cursor-pointer overflow-hidden">
                        <img id="pImg3" class="w-full h-full object-cover hidden">
                        <span id="pTxt3" class="text-[10px] text-slate-400 font-bold">وێنە ٣</span>
                    </div>
                </div>
                <input type="file" id="fInp1" class="hidden" accept="image/*" onchange="handleImg(event, 1)">
                <input type="file" id="fInp2" class="hidden" accept="image/*" onchange="handleImg(event, 2)">
                <input type="file" id="fInp3" class="hidden" accept="image/*" onchange="handleImg(event, 3)">
                <input type="text" id="pName" class="w-full p-4 bg-slate-50 rounded-xl outline-none font-bold text-sm">
                <input type="number" id="pPrice" class="w-full p-4 bg-slate-50 rounded-xl outline-none font-black text-blue-700">
                <input type="tel" id="pPhone" class="w-full p-4 bg-slate-50 rounded-xl outline-none font-bold text-sm">
                <button onclick="submitPost()" id="ui-submit" class="w-full bg-blue-600 text-white py-4 rounded-xl font-black text-lg active:scale-95 transition-all"></button>
                <button onclick="toggleModal(false)" id="ui-close" class="w-full text-slate-500 font-bold text-xs text-center mt-3"></button>
            </div>
        </div>
    </div>
    <div id="confirmModal" class="fixed inset-0 bg-black/60 hidden items-center justify-center p-6 z-[200]">
        <div class="bg-white w-full max-w-xs rounded-2xl p-8 text-center shadow-2xl">
            <h3 id="ui-conf-title" class="text-xl font-black text-slate-800 mb-2"></h3>
            <p id="ui-conf-msg" class="text-slate-500 font-bold text-sm mb-8"></p>
            <div class="flex gap-3">
                <button id="confirmYes" class="flex-1 bg-red-600 text-white py-3.5 rounded-xl font-black"></button>
                <button onclick="closeConfirm()" id="confirmNo" class="flex-1 bg-slate-100 text-slate-600 py-3.5 rounded-xl font-black"></button>
            </div>
        </div>
    </div>
    <div id="detailModal" class="fixed inset-0 bg-white hidden z-[150] flex-col overflow-hidden">
        <div id="detailContent" class="flex-1 overflow-y-auto">
             <div class="swiper mySwiper">
                <div class="swiper-wrapper" id="sliderWrapper"></div>
                <div class="swiper-pagination"></div>
            </div>
            <div id="detailText" class="p-8"></div>
        </div>
        <div class="p-6 border-t flex flex-col gap-3">
            <a id="callBtn" href="" class="w-full bg-blue-600 text-white py-4 rounded-2xl font-black text-center text-lg"></a>
            <button id="delBtn" class="w-full py-4 text-red-600 font-black bg-red-50 rounded-2xl hidden"></button>
            <button onclick="closeDetails()" id="ui-back" class="w-full text-slate-400 font-bold text-xs text-center"></button>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
    <script>
        let lang = 'sorani'; let cat = 'هەمووی'; 
        let currentImgs = ["", "", ""];
        let swiperInstance = null;
        const myId = localStorage.getItem('user_id') || ('u' + Date.now());
        localStorage.setItem('user_id', myId);
        const dict = {
            sorani: { 
                add: "بڵاوکردنەوە +", search: "بگەڕێ بۆ کاڵاکان...", title: "بڵاوکردنەوەی نوێ", 
                name: "ناوی کاڵا", price: "نرخ $", submit: "بڵاوکردنەوە", close: "داخستن", 
                now: "ئێستا", min: "دەقە", hour: "کاتژمێر", day: "ڕۆژ", del: "سڕینەوەی پۆست", 
                confT: "سڕینەوە", confM: "ئایا دڵنیای لە سڕینەوە؟", 
                yes: "بەڵێ", no: "نەخێر", back: "گەڕانەوە", imgT: "وێنەی کاڵا",
                call: "پەیوەندی بکە", cats: ["هەمووی", "ئۆتۆمبێل", "مۆبایل", "خانوو", "هەمەجۆر"] 
            },
            badini: { 
                add: "بەلاڤکرن +", search: "لێگەڕیان...", title: "بەلاڤکرنا نوی", 
                name: "ناڤێ کالای", price: "بها $", submit: "بەلاڤکە", close: "داخستن", 
                now: "نوکە", min: "دەقە", hour: "سەعەت", day: "ڕۆژ", del: "ژێبرنا پۆستی", 
                confT: "ژێبرن", confM: "تۆ یێ پشت راستی؟", 
                yes: "بەڵێ", no: "نەخێر", back: "زڤڕین", imgT: "وێنێ کالای",
                call: "پەیوەندیێ بکە", cats: ["هەمی", "ترومبێل", "مۆبایل", "خانی", "هەمەجۆر"] 
            }
        };
        function setLanguage(l) {
            lang = l;
            document.getElementById('btn-sorani').className = `px-4 py-1.5 rounded-xl text-[11px] font-bold ${l === 'sorani' ? 'bg-white text-blue-900 shadow-sm' : 'text-white/40'}`;
            document.getElementById('btn-badini').className = `px-4 py-1.5 rounded-xl text-[11px] font-bold ${l === 'badini' ? 'bg-white text-blue-900 shadow-sm' : 'text-white/40'}`;
            refreshUI(); renderData();
        }
        function refreshUI() {
            const d = dict[lang];
            document.getElementById('ui-add-btn').innerText = d.add;
            document.getElementById('searchInp').placeholder = d.search;
            document.getElementById('ui-title').innerText = d.title;
            document.getElementById('pName').placeholder = d.name;
            document.getElementById('pPrice').placeholder = d.price;
            document.getElementById('pPhone').placeholder = "07XX XXX XXXX";
            document.getElementById('ui-submit').innerText = d.submit;
            document.getElementById('ui-close').innerText = d.close;
            document.getElementById('ui-conf-title').innerText = d.confT;
            document.getElementById('ui-conf-msg').innerText = d.confM;
            document.getElementById('confirmYes').innerText = d.yes;
            document.getElementById('confirmNo').innerText = d.no;
            document.getElementById('ui-back').innerText = d.back;
            document.getElementById('delBtn').innerText = d.del;
            const list = document.getElementById('catList'); list.innerHTML = "";
            dict[lang].cats.forEach((c, i) => {
                const isAct = cat === dict['sorani'].cats[i];
                list.innerHTML += `<button onclick="setCat('${dict['sorani'].cats[i]}')" class="cat-chip ${isAct?'active':''} shadow-sm">${c}</button>`;
            });
            const sel = document.getElementById('pCat'); sel.innerHTML = "";
            dict[lang].cats.slice(1).forEach((c, i) => {
                sel.innerHTML += `<option value="${dict['sorani'].cats[i+1]}">${c}</option>`;
            });
        }
        function setCat(c) { cat = c; refreshUI(); renderData(); }
        function timeSince(ts) {
            const s = Math.floor((Date.now() - ts) / 1000);
            const d = dict[lang];
            if (s < 60) return d.now;
            if (s < 3600) return Math.floor(s/60) + " " + d.min;
            if (s < 86400) return Math.floor(s/3600) + " " + d.hour;
            return Math.floor(s/86400) + " " + d.day;
        }
        async function renderData() {
            const grid = document.getElementById('grid');
            const q = document.getElementById('searchInp').value.toLowerCase();
            const res = await fetch('/api/posts'); 
            const posts = await res.json();
            grid.innerHTML = "";
            posts.filter(p => (cat === 'هەمووی' || p.category === cat) && p.name.toLowerCase().includes(q)).forEach(p => {
                grid.innerHTML += `
                    <div class="card shadow-sm active:scale-95 transition-all" onclick='showDetails(${JSON.stringify(p)})'>
                        <div class="h-44 relative overflow-hidden"><img src="${p.imgs[0]}" class="w-full h-full object-cover"></div>
                        <div class="p-4">
                            <h3 class="font-bold text-[13px] truncate text-slate-800">${p.name}</h3>
                            <div class="flex justify-between items-center mt-3">
                                <span class="text-blue-700 font-black text-sm">$${p.price}</span>
                                <span class="text-[9px] font-bold text-slate-400">${timeSince(p.time)}</span>
                            </div>
                        </div>
                    </div>`;
            });
        }
        function showDetails(p) {
            const wrapper = document.getElementById('sliderWrapper');
            const imgs = p.imgs.filter(img => img !== "");
            wrapper.innerHTML = imgs.map(img => `
                <div class="swiper-slide"><img src="${img}" class="w-full h-full object-cover"></div>
            `).join("");
            document.getElementById('detailText').innerHTML = `
                <h2 class="text-3xl font-black text-slate-900 mb-2">${p.name}</h2>
                <p class="text-blue-600 font-black text-4xl mb-6">$${p.price}</p>
                <div class="bg-slate-50 p-4 rounded-xl text-slate-500 font-bold text-xs inline-block">${timeSince(p.time)}</div>
            `;
            document.getElementById('callBtn').href = "tel:" + p.phone;
            document.getElementById('callBtn').innerText = dict[lang].call;
            const delBtn = document.getElementById('delBtn');
            if(p.owner_id === myId) {
                delBtn.classList.remove('hidden');
                delBtn.onclick = () => openConfirm(p.id);
            } else {
                delBtn.classList.add('hidden');
            }
            document.getElementById('detailModal').classList.replace('hidden', 'flex');
            if(swiperInstance) swiperInstance.destroy();
            swiperInstance = new Swiper(".mySwiper", {
                pagination: { el: ".swiper-pagination", clickable: true },
                autoplay: { delay: 7000, disableOnInteraction: false },
                loop: imgs.length > 1,
                grabCursor: true,
                on: { touchEnd: function() { this.autoplay.start(); } }
            });
        }
        function openConfirm(postId) {
            document.getElementById('confirmModal').classList.replace('hidden', 'flex');
            document.getElementById('confirmYes').onclick = async () => {
                await fetch(`/api/posts/${postId}?uid=${myId}`, { method: 'DELETE' });
                closeConfirm(); closeDetails(); renderData();
            };
        }
        function closeConfirm() { document.getElementById('confirmModal').classList.replace('flex', 'hidden'); }
        function closeDetails() { document.getElementById('detailModal').classList.replace('flex', 'hidden'); }
        function handleImg(e, num) {
            const reader = new FileReader();
            reader.onload = (v) => {
                currentImgs[num-1] = v.target.result;
                document.getElementById(`pImg${num}`).src = v.target.result;
                document.getElementById(`pImg${num}`).classList.remove('hidden');
                document.getElementById(`pTxt${num}`).classList.add('hidden');
            };
            reader.readAsDataURL(e.target.files[0]);
        }
        async function submitPost() {
            const name = document.getElementById('pName').value;
            const price = document.getElementById('pPrice').value;
            const phone = document.getElementById('pPhone').value;
            const category = document.getElementById('pCat').value;
            if(!currentImgs[0] || !name || !phone) return alert("تکایە وێنەی یەکەم و زانیارییەکان پڕ بکەرەوە");
            const newPost = { 
                id: Date.now(), 
                time: Date.now(), 
                category: category, 
                name: name, 
                price: price, 
                phone: phone, 
                imgs: currentImgs.filter(i => i !== ""), 
                owner_id: myId 
            };
            toggleModal(false);
            await fetch('/api/posts', { 
                method: 'POST', 
                headers: {'Content-Type': 'application/json'}, 
                body: JSON.stringify(newPost) 
            });
            renderData();
        }
        function toggleModal(s) { 
            document.getElementById('modal').classList.toggle('hidden', !s); 
            document.getElementById('modal').classList.toggle('flex', s);
            if(!s) { 
                currentImgs = ["", "", ""];
                for(let i=1; i<=3; i++) {
                    document.getElementById(`pImg${i}`).classList.add('hidden'); 
                    document.getElementById(`pTxt${i}`).classList.remove('hidden');
                }
                document.getElementById('pName').value = ""; 
                document.getElementById('pPrice').value = ""; 
                document.getElementById('pPhone').value = "";
            }
        }
        setLanguage('sorani');
    </script>
</body>
</html>
"""

@app.route('/')
def index(): return render_template_string(HTML_TEMPLATE)

@app.route('/api/posts', methods=['GET'])
def get_posts(): return jsonify(all_posts)

@app.route('/api/posts', methods=['POST'])
def add_post():
    all_posts.insert(0, request.json)
    return jsonify({"status": "ok"})

@app.route('/api/posts/<int:post_id>', methods=['DELETE'])
def delete_post(post_id):
    global all_posts
    user_id = request.args.get('uid')
    post = next((p for p in all_posts if p['id'] == post_id), None)
    if post and post.get('owner_id') == user_id:
        all_posts = [p for p in all_posts if p['id'] != post_id]
        return jsonify({"status": "deleted"})
    return jsonify({"status": "unauthorized"}), 403

