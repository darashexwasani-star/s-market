from flask import Flask, render_template_string, request, jsonify
from flask_cors import CORS
import json, os

app = Flask(__name__)
CORS(app, resources={r"/api/*": {"origins": "*"}})

DATA_FILE = 'posts.json'

def load_posts():
    if os.path.exists(DATA_FILE):
        try:
            with open(DATA_FILE, 'r', encoding='utf-8') as f:
                return json.load(f)
        except:
            return []
    return []

def save_posts(posts):
    with open(DATA_FILE, 'w', encoding='utf-8') as f:
        json.dump(posts, f, ensure_ascii=False)

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
        .upload-box { height: 96px; background: #f8fafc; border-radius: 12px; border: 2px dashed #e2e8f0; display: flex; align-items: center; justify-content: center; cursor: pointer; overflow: hidden; position: relative; }
        .upload-box img { width: 100%; height: 100%; object-fit: cover; }
        .upload-box .remove-btn { position: absolute; top: 4px; left: 4px; background: rgba(239,68,68,0.85); color: white; border-radius: 50%; width: 20px; height: 20px; display: flex; align-items: center; justify-content: center; font-size: 12px; font-weight: 900; cursor: pointer; z-index:10; }
        .toast { position: fixed; bottom: 32px; left: 50%; transform: translateX(-50%) translateY(80px); background: #1e293b; color: white; padding: 14px 28px; border-radius: 16px; font-weight: 700; font-size: 14px; z-index: 9999; opacity: 0; transition: all 0.35s cubic-bezier(.68,-.55,.27,1.55); pointer-events: none; }
        .toast.show { opacity: 1; transform: translateX(-50%) translateY(0); }
        .loading-overlay { position: fixed; inset: 0; background: rgba(255,255,255,0.7); display: flex; align-items: center; justify-content: center; z-index: 9998; }
        .spinner { width: 48px; height: 48px; border: 5px solid #e2e8f0; border-top-color: #1e40af; border-radius: 50%; animation: spin 0.8s linear infinite; }
        @keyframes spin { to { transform: rotate(360deg); } }
        .empty-state { grid-column: 1/-1; display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 60px 0; color: #94a3b8; }
        .empty-state svg { width: 64px; height: 64px; margin-bottom: 16px; opacity: 0.4; }
    </style>
</head>
<body>

    <div id="toast" class="toast"></div>

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
                <use xlink:href="#wave-path" x="48" y="0" />
                <use xlink:href="#wave-path" x="48" y="3" />
                <use xlink:href="#wave-path" x="48" y="5" />
                <use xlink:href="#wave-path" x="48" y="7" />
            </g>
        </svg>
    </div>

    <div id="catList" class="flex gap-3 overflow-x-auto no-scrollbar px-6 py-8"></div>
    <main class="px-6 pb-32"><div id="grid" class="grid grid-cols-2 md:grid-cols-4 gap-6"></div></main>

    <!-- Modal زیادکردن -->
    <div id="modal" class="fixed inset-0 bg-black/30 hidden items-center justify-center p-6 z-[100] backdrop-blur-sm">
        <div class="glass-modal w-full max-w-sm p-8 max-h-[90vh] overflow-y-auto shadow-2xl">
            <h2 id="ui-title" class="text-2xl font-black mb-8 text-slate-800 text-center"></h2>
            <div class="space-y-4">
                <select id="pCat" class="w-full p-4 bg-slate-50 rounded-xl font-bold outline-none border border-slate-100"></select>

                <!-- ئەپلۆدی وێنەکان -->
                <div class="grid grid-cols-3 gap-2">
                    <div id="box1" class="upload-box" onclick="document.getElementById('fInp1').click()">
                        <img id="pImg1" class="hidden">
                        <span id="pTxt1" class="text-[10px] text-slate-400 font-bold">وێنە ١</span>
                    </div>
                    <div id="box2" class="upload-box" onclick="document.getElementById('fInp2').click()">
                        <img id="pImg2" class="hidden">
                        <span id="pTxt2" class="text-[10px] text-slate-400 font-bold">وێنە ٢</span>
                    </div>
                    <div id="box3" class="upload-box" onclick="document.getElementById('fInp3').click()">
                        <img id="pImg3" class="hidden">
                        <span id="pTxt3" class="text-[10px] text-slate-400 font-bold">وێنە ٣</span>
                    </div>
                </div>

                <input type="file" id="fInp1" class="hidden" accept="image/*" onchange="handleImg(event, 1)">
                <input type="file" id="fInp2" class="hidden" accept="image/*" onchange="handleImg(event, 2)">
                <input type="file" id="fInp3" class="hidden" accept="image/*" onchange="handleImg(event, 3)">

                <input type="text" id="pName" class="w-full p-4 bg-slate-50 rounded-xl outline-none font-bold text-sm border border-transparent focus:border-blue-300 transition-all">
                <input type="number" id="pPrice" class="w-full p-4 bg-slate-50 rounded-xl outline-none font-black text-blue-700 border border-transparent focus:border-blue-300 transition-all">
                <input type="tel" id="pPhone" class="w-full p-4 bg-slate-50 rounded-xl outline-none font-bold text-sm border border-transparent focus:border-blue-300 transition-all">
                <button onclick="submitPost()" id="ui-submit" class="w-full bg-blue-600 text-white py-4 rounded-xl font-black text-lg active:scale-95 transition-all disabled:opacity-50"></button>
                <button onclick="toggleModal(false)" id="ui-close" class="w-full text-slate-500 font-bold text-xs text-center mt-3"></button>
            </div>
        </div>
    </div>

    <!-- Modal دڵنیابوونەوە -->
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

    <!-- Modal دیتایل -->
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
        let lang = 'sorani';
        let cat = 'هەمووی';
        let currentImgs = ["", "", ""];
        let swiperInstance = null;
        let isSubmitting = false;

        // --- ئایدی بەکارهێنەر: UUID ڕاستەقینە ---
        function generateUUID() {
            return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
                const r = Math.random() * 16 | 0;
                return (c === 'x' ? r : (r & 0x3 | 0x8)).toString(16);
            });
        }
        const myId = localStorage.getItem('user_id') || generateUUID();
        localStorage.setItem('user_id', myId);

        const dict = {
            sorani: {
                add: "بڵاوکردنەوە +", search: "بگەڕێ بۆ کاڵاکان...", title: "بڵاوکردنەوەی نوێ",
                name: "ناوی کاڵا", price: "نرخ $", submit: "بڵاوکردنەوە", close: "داخستن",
                now: "ئێستا", min: "دەقە", hour: "کاتژمێر", day: "ڕۆژ", del: "سڕینەوەی پۆست",
                confT: "سڕینەوە", confM: "ئایا دڵنیای لە سڕینەوە؟",
                yes: "بەڵێ", no: "نەخێر", back: "گەڕانەوە",
                call: "پەیوەندی بکە", phone: "07XX XXX XXXX",
                empty: "هیچ کاڵایەک نەدۆزرایەوە",
                errImg: "تکایە لانیکەم وێنەیەک هەڵبژێرە",
                errFields: "تکایە هەموو خانەکان پڕ بکەرەوە",
                errPhone: "ژمارەی تەلەفۆن دروست نییە",
                cats: ["هەمووی", "ئۆتۆمبێل", "مۆبایل", "خانوو", "هەمەجۆر"]
            },
            badini: {
                add: "بەلاڤکرن +", search: "لێگەڕیان...", title: "بەلاڤکرنا نوی",
                name: "ناڤێ کالای", price: "بها $", submit: "بەلاڤکە", close: "داخستن",
                now: "نوکە", min: "دەقە", hour: "سەعەت", day: "ڕۆژ", del: "ژێبرنا پۆستی",
                confT: "ژێبرن", confM: "تۆ یێ پشت راستی؟",
                yes: "بەڵێ", no: "نەخێر", back: "زڤڕین",
                call: "پەیوەندیێ بکە", phone: "07XX XXX XXXX",
                empty: "هیچ کالایێک نەهات دیتن",
                errImg: "تکایە لانیکم وێنەیەک هەڵبژێرە",
                errFields: "تکایە هەموو خانەکان پڕ بکەرەوە",
                errPhone: "ژمارەی تەلەفۆن دروست نییە",
                cats: ["هەمی", "ترومبێل", "مۆبایل", "خانی", "هەمەجۆر"]
            }
        };

        // --- تۆست ---
        function showToast(msg, duration = 2500) {
            const t = document.getElementById('toast');
            t.innerText = msg;
            t.classList.add('show');
            setTimeout(() => t.classList.remove('show'), duration);
        }

        // --- زمان ---
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
            document.getElementById('pPhone').placeholder = d.phone;
            document.getElementById('ui-submit').innerText = d.submit;
            document.getElementById('ui-close').innerText = d.close;
            document.getElementById('ui-conf-title').innerText = d.confT;
            document.getElementById('ui-conf-msg').innerText = d.confM;
            document.getElementById('confirmYes').innerText = d.yes;
            document.getElementById('confirmNo').innerText = d.no;
            document.getElementById('ui-back').innerText = d.back;
            document.getElementById('delBtn').innerText = d.del;

            const list = document.getElementById('catList');
            list.innerHTML = "";
            dict[lang].cats.forEach((c, i) => {
                const isAct = cat === dict['sorani'].cats[i];
                list.innerHTML += `<button onclick="setCat('${dict['sorani'].cats[i]}')" class="cat-chip ${isAct ? 'active' : ''} shadow-sm">${c}</button>`;
            });

            const sel = document.getElementById('pCat');
            sel.innerHTML = "";
            dict[lang].cats.slice(1).forEach((c, i) => {
                sel.innerHTML += `<option value="${dict['sorani'].cats[i + 1]}">${c}</option>`;
            });
        }

        function setCat(c) { cat = c; refreshUI(); renderData(); }

        function timeSince(ts) {
            const s = Math.floor((Date.now() - ts) / 1000);
            const d = dict[lang];
            if (s < 60) return d.now;
            if (s < 3600) return Math.floor(s / 60) + " " + d.min;
            if (s < 86400) return Math.floor(s / 3600) + " " + d.hour;
            return Math.floor(s / 86400) + " " + d.day;
        }

        // --- نیشاندانی کاڵاکان ---
        async function renderData() {
            const grid = document.getElementById('grid');
            const q = document.getElementById('searchInp').value.toLowerCase();
            try {
                const res = await fetch('/api/posts');
                if (!res.ok) throw new Error('fetch failed');
                const posts = await res.json();
                const filtered = posts.filter(p =>
                    (cat === 'هەمووی' || p.category === cat) &&
                    p.name.toLowerCase().includes(q)
                );
                if (filtered.length === 0) {
                    grid.innerHTML = `<div class="empty-state">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4" /></svg>
                        <p class="font-bold text-sm">${dict[lang].empty}</p>
                    </div>`;
                    return;
                }
                grid.innerHTML = filtered.map(p => `
                    <div class="card shadow-sm active:scale-95 transition-all cursor-pointer" onclick='showDetails(${JSON.stringify(p).replace(/'/g, "&#39;")})'>
                        <div class="h-44 relative overflow-hidden bg-slate-100">
                            <img src="${p.imgs[0]}" class="w-full h-full object-cover" loading="lazy" onerror="this.src='data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 1 1%22><rect fill=%22%23f1f5f9%22/></svg>'">
                        </div>
                        <div class="p-4">
                            <h3 class="font-bold text-[13px] truncate text-slate-800">${escapeHtml(p.name)}</h3>
                            <div class="flex justify-between items-center mt-3">
                                <span class="text-blue-700 font-black text-sm">$${escapeHtml(String(p.price))}</span>
                                <span class="text-[9px] font-bold text-slate-400">${timeSince(p.time)}</span>
                            </div>
                        </div>
                    </div>`).join('');
            } catch (e) {
                console.error('renderData error:', e);
            }
        }

        function escapeHtml(str) {
            return String(str).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
        }

        // --- دیتایل ---
        function showDetails(p) {
            const wrapper = document.getElementById('sliderWrapper');
            const imgs = p.imgs.filter(img => img && img !== "");
            wrapper.innerHTML = imgs.map(img =>
                `<div class="swiper-slide"><img src="${img}" class="w-full h-full object-cover"></div>`
            ).join("");

            document.getElementById('detailText').innerHTML = `
                <h2 class="text-3xl font-black text-slate-900 mb-2">${escapeHtml(p.name)}</h2>
                <p class="text-blue-600 font-black text-4xl mb-6">$${escapeHtml(String(p.price))}</p>
                <div class="bg-slate-50 p-4 rounded-xl text-slate-500 font-bold text-xs inline-block">${timeSince(p.time)}</div>
            `;

            document.getElementById('callBtn').href = "tel:" + p.phone;
            document.getElementById('callBtn').innerText = dict[lang].call;

            const delBtn = document.getElementById('delBtn');
            if (p.owner_id === myId) {
                delBtn.classList.remove('hidden');
                delBtn.onclick = () => openConfirm(p.id);
            } else {
                delBtn.classList.add('hidden');
            }

            document.getElementById('detailModal').classList.replace('hidden', 'flex');

            if (swiperInstance) { swiperInstance.destroy(true, true); swiperInstance = null; }
            setTimeout(() => {
                swiperInstance = new Swiper(".mySwiper", {
                    pagination: { el: ".swiper-pagination", clickable: true },
                    autoplay: imgs.length > 1 ? { delay: 7000, disableOnInteraction: false } : false,
                    loop: imgs.length > 1,
                    grabCursor: true,
                });
            }, 100);
        }

        function openConfirm(postId) {
            document.getElementById('confirmModal').classList.replace('hidden', 'flex');
            document.getElementById('confirmYes').onclick = async () => {
                try {
                    const res = await fetch(`/api/posts/${postId}?uid=${encodeURIComponent(myId)}`, { method: 'DELETE' });
                    if (res.ok) {
                        showToast('✅ سڕایەوە');
                        closeConfirm(); closeDetails(); renderData();
                    } else {
                        showToast('❌ کەوتە هەڵە');
                    }
                } catch (e) {
                    showToast('❌ هەڵەی تۆڕ');
                }
            };
        }
        function closeConfirm() { document.getElementById('confirmModal').classList.replace('flex', 'hidden'); }
        function closeDetails() { document.getElementById('detailModal').classList.replace('flex', 'hidden'); }

        // --- ئەپلۆدی وێنە (کەم کردنەوەی قەبارە) ---
        function compressImage(file, maxWidth = 800, quality = 0.75) {
            return new Promise((resolve) => {
                const reader = new FileReader();
                reader.onload = (e) => {
                    const img = new Image();
                    img.onload = () => {
                        const canvas = document.createElement('canvas');
                        let w = img.width, h = img.height;
                        if (w > maxWidth) { h = Math.round(h * maxWidth / w); w = maxWidth; }
                        canvas.width = w; canvas.height = h;
                        canvas.getContext('2d').drawImage(img, 0, 0, w, h);
                        resolve(canvas.toDataURL('image/jpeg', quality));
                    };
                    img.src = e.target.result;
                };
                reader.readAsDataURL(file);
            });
        }

        async function handleImg(e, num) {
            const file = e.target.files[0];
            if (!file) return;
            // چێکردنەوەی قەبارە
            if (file.size > 5 * 1024 * 1024) {
                showToast('❌ وێنەکە زۆر گەورەیە (زیاتر لە 5MB)');
                e.target.value = '';
                return;
            }
            const compressed = await compressImage(file);
            currentImgs[num - 1] = compressed;
            const imgEl = document.getElementById(`pImg${num}`);
            const txtEl = document.getElementById(`pTxt${num}`);
            imgEl.src = compressed;
            imgEl.classList.remove('hidden');
            txtEl.classList.add('hidden');
            // دووگمەی سڕینەوەی وێنە
            const box = document.getElementById(`box${num}`);
            let rmBtn = box.querySelector('.remove-btn');
            if (!rmBtn) {
                rmBtn = document.createElement('span');
                rmBtn.className = 'remove-btn';
                rmBtn.innerText = '×';
                rmBtn.onclick = (ev) => { ev.stopPropagation(); removeImg(num); };
                box.appendChild(rmBtn);
            }
        }

        function removeImg(num) {
            currentImgs[num - 1] = "";
            document.getElementById(`pImg${num}`).classList.add('hidden');
            document.getElementById(`pImg${num}`).src = '';
            document.getElementById(`pTxt${num}`).classList.remove('hidden');
            document.getElementById(`fInp${num}`).value = '';
            const box = document.getElementById(`box${num}`);
            const rmBtn = box.querySelector('.remove-btn');
            if (rmBtn) rmBtn.remove();
        }

        // --- ناردنی پۆست ---
        async function submitPost() {
            if (isSubmitting) return;
            const d = dict[lang];
            const name = document.getElementById('pName').value.trim();
            const price = document.getElementById('pPrice').value.trim();
            const phone = document.getElementById('pPhone').value.trim();
            const category = document.getElementById('pCat').value;
            const validImgs = currentImgs.filter(i => i !== "");

            // پشکنینی داخڵکراوەکان
            if (validImgs.length === 0) { showToast(d.errImg); return; }
            if (!name || !price) { showToast(d.errFields); return; }
            if (!phone || phone.length < 7) { showToast(d.errPhone); return; }

            isSubmitting = true;
            document.getElementById('ui-submit').disabled = true;

            const newPost = {
                id: `${Date.now()}-${Math.random().toString(36).substr(2, 9)}`,
                time: Date.now(),
                category,
                name,
                price,
                phone,
                imgs: validImgs,
                owner_id: myId
            };

            try {
                const res = await fetch('/api/posts', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(newPost)
                });
                if (res.ok) {
                    toggleModal(false);
                    showToast('✅ بڵاوکرایەوە!');
                    renderData();
                } else {
                    showToast('❌ هەڵەی سێرڤەر');
                }
            } catch (e) {
                showToast('❌ هەڵەی تۆڕ');
            } finally {
                isSubmitting = false;
                document.getElementById('ui-submit').disabled = false;
            }
        }

        // --- Modal ---
        function toggleModal(s) {
            document.getElementById('modal').classList.toggle('hidden', !s);
            document.getElementById('modal').classList.toggle('flex', s);
            if (!s) {
                currentImgs = ["", "", ""];
                for (let i = 1; i <= 3; i++) {
                    document.getElementById(`pImg${i}`).classList.add('hidden');
                    document.getElementById(`pImg${i}`).src = '';
                    document.getElementById(`pTxt${i}`).classList.remove('hidden');
                    document.getElementById(`fInp${i}`).value = '';
                    const rmBtn = document.getElementById(`box${i}`).querySelector('.remove-btn');
                    if (rmBtn) rmBtn.remove();
                }
                document.getElementById('pName').value = "";
                document.getElementById('pPrice').value = "";
                document.getElementById('pPhone').value = "";
            }
        }

        // دەستپێکردن
        setLanguage('sorani');
    </script>
</body>
</html>
"""

@app.route('/')
def index():
    return render_template_string(HTML_TEMPLATE)

@app.route('/api/posts', methods=['GET'])
def get_posts():
    try:
        return jsonify(load_posts())
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/posts', methods=['POST'])
def add_post():
    try:
        data = request.json
        if not data:
            return jsonify({"error": "no data"}), 400
        # پشکنینی خانەی پێویست
        required = ['id', 'name', 'price', 'phone', 'imgs', 'owner_id', 'category', 'time']
        for field in required:
            if field not in data:
                return jsonify({"error": f"missing field: {field}"}), 400
        posts = load_posts()
        posts.insert(0, data)
        save_posts(posts)
        return jsonify({"status": "ok"})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/posts/<post_id>', methods=['DELETE'])
def delete_post(post_id):
    try:
        user_id = request.args.get('uid')
        if not user_id:
            return jsonify({"error": "uid required"}), 400
        posts = load_posts()
        post = next((p for p in posts if str(p['id']) == str(post_id)), None)
        if not post:
            return jsonify({"error": "not found"}), 404
        if post.get('owner_id') != user_id:
            return jsonify({"status": "unauthorized"}), 403
        posts = [p for p in posts if str(p['id']) != str(post_id)]
        save_posts(posts)
        return jsonify({"status": "deleted"})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
