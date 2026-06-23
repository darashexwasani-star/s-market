<!DOCTYPE html>
<html lang="ku" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>S-MARKET</title>
<script src="https://cdn.tailwindcss.com"></script>
<link href="https://fonts.googleapis.com/css2?family=Vazirmatn:wght@300;400;500;600;700;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css"/>
<style>
  :root {
    --navy:   #0B1D3A;
    --gold:   #C9A84C;
    --gold-l: #E8C97A;
    --cream:  #F7F4EF;
    --ink:    #1C2B3A;
    --mist:   #8A99AA;
    --line:   #E4DDD3;
  }
  * { box-sizing: border-box; }
  body { font-family: 'Vazirmatn', sans-serif; background: var(--cream); color: var(--ink); margin: 0; overflow-x: hidden; }

  /* ── هێدەر ── */
  .header {
    background: var(--navy);
    position: relative;
    overflow: hidden;
    padding: 0 0 56px;
  }
  .header::after {
    content: '';
    position: absolute;
    bottom: -1px; left: 0; right: 0;
    height: 56px;
    background: var(--cream);
    clip-path: ellipse(55% 100% at 50% 100%);
  }
  .header-inner { position: relative; z-index: 2; padding: 28px 24px 0; }

  /* خەتی زێڕین */
  .gold-line { display: flex; align-items: center; gap: 10px; margin-bottom: 6px; }
  .gold-line::before, .gold-line::after {
    content: ''; flex: 1; height: 1px; background: var(--gold); opacity: 0.4;
  }
  .gold-dot { width: 5px; height: 5px; border-radius: 50%; background: var(--gold); }

  .brand { text-align: center; margin-bottom: 28px; }
  .brand-sub { font-size: 10px; letter-spacing: 0.35em; color: var(--gold); font-weight: 600; text-transform: uppercase; margin-bottom: 6px; }
  .brand-name { font-size: 36px; font-weight: 900; color: #fff; letter-spacing: -0.02em; line-height: 1; }
  .brand-name span { color: var(--gold); }

  /* سرچ بار */
  .search-wrap { display: flex; gap: 10px; margin-bottom: 0; }
  .search-inp {
    flex: 1; background: rgba(255,255,255,0.08); border: 1px solid rgba(201,168,76,0.3);
    border-radius: 14px; padding: 14px 18px; color: #fff; font-family: 'Vazirmatn', sans-serif;
    font-size: 13px; font-weight: 500; outline: none;
    transition: border-color 0.2s;
  }
  .search-inp::placeholder { color: rgba(255,255,255,0.35); }
  .search-inp:focus { border-color: var(--gold); }
  .add-btn {
    background: linear-gradient(135deg, var(--gold) 0%, var(--gold-l) 100%);
    color: var(--navy); border: none; border-radius: 14px; padding: 14px 20px;
    font-family: 'Vazirmatn', sans-serif; font-size: 12px; font-weight: 900;
    cursor: pointer; white-space: nowrap; transition: opacity 0.2s, transform 0.1s;
    box-shadow: 0 4px 16px rgba(201,168,76,0.35);
  }
  .add-btn:active { transform: scale(0.96); opacity: 0.9; }

  /* لانگ سویچ */
  .lang-switch {
    display: flex; gap: 0; background: rgba(255,255,255,0.08);
    border: 1px solid rgba(255,255,255,0.1); border-radius: 10px; overflow: hidden;
    margin-bottom: 20px; align-self: flex-end; width: fit-content; margin-right: auto;
  }
  .lang-btn {
    padding: 7px 14px; font-size: 11px; font-weight: 700; border: none;
    background: transparent; color: rgba(255,255,255,0.4); cursor: pointer;
    font-family: 'Vazirmatn', sans-serif; transition: all 0.2s;
  }
  .lang-btn.active { background: var(--gold); color: var(--navy); }

  /* کاتیگۆری */
  .cat-strip { overflow-x: auto; display: flex; gap: 8px; padding: 28px 24px 12px; scrollbar-width: none; }
  .cat-strip::-webkit-scrollbar { display: none; }
  .cat-btn {
    white-space: nowrap; padding: 9px 20px; border-radius: 10px;
    font-size: 12px; font-weight: 700; border: 1.5px solid var(--line);
    background: #fff; color: var(--mist); cursor: pointer; transition: all 0.2s;
    font-family: 'Vazirmatn', sans-serif;
  }
  .cat-btn.active { background: var(--navy); color: var(--gold); border-color: var(--navy); }

  /* گرید */
  .grid-wrap { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; padding: 8px 16px 120px; }
  @media(min-width:768px){ .grid-wrap { grid-template-columns: repeat(4,1fr); padding: 8px 24px 120px; } }

  /* کارد */
  .card {
    background: #fff; border-radius: 18px; overflow: hidden;
    border: 1px solid var(--line); cursor: pointer;
    transition: transform 0.2s, box-shadow 0.2s;
    box-shadow: 0 2px 8px rgba(11,29,58,0.06);
  }
  .card:active { transform: scale(0.97); box-shadow: 0 1px 4px rgba(11,29,58,0.08); }
  .card-img { height: 160px; overflow: hidden; background: #f0ece6; position: relative; }
  .card-img img { width: 100%; height: 100%; object-fit: cover; display: block; }
  .card-badge {
    position: absolute; top: 10px; right: 10px;
    background: var(--navy); color: var(--gold);
    font-size: 9px; font-weight: 700; padding: 3px 8px; border-radius: 6px;
    letter-spacing: 0.05em;
  }
  .card-body { padding: 14px; }
  .card-name { font-size: 12px; font-weight: 700; color: var(--ink); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-bottom: 10px; }
  .card-foot { display: flex; justify-content: space-between; align-items: center; }
  .card-price { font-size: 15px; font-weight: 900; color: var(--navy); }
  .card-price span { font-size: 10px; font-weight: 500; color: var(--gold); margin-right: 2px; }
  .card-time { font-size: 9px; font-weight: 600; color: var(--mist); }

  /* ── مۆدالی زیادکردن ── */
  .overlay {
    position: fixed; inset: 0; background: rgba(11,29,58,0.55);
    display: none; align-items: flex-end; justify-content: center;
    z-index: 100; backdrop-filter: blur(4px);
  }
  .overlay.open { display: flex; }
  .sheet {
    background: #fff; border-radius: 28px 28px 0 0;
    width: 100%; max-width: 520px; padding: 0 24px 40px;
    max-height: 92vh; overflow-y: auto;
  }
  .sheet-handle { width: 40px; height: 4px; background: var(--line); border-radius: 4px; margin: 14px auto 24px; }
  .sheet-title {
    text-align: center; font-size: 18px; font-weight: 900; color: var(--navy);
    margin-bottom: 24px; display: flex; align-items: center; gap: 10px; justify-content: center;
  }
  .sheet-title::before, .sheet-title::after {
    content: ''; flex: 1; max-width: 40px; height: 1px; background: var(--gold); opacity: 0.5;
  }

  /* فۆرم */
  .f-label { font-size: 11px; font-weight: 700; color: var(--mist); letter-spacing: 0.05em; margin-bottom: 6px; display: block; }
  .f-inp {
    width: 100%; padding: 13px 16px; background: var(--cream); border: 1.5px solid var(--line);
    border-radius: 12px; font-size: 13px; font-weight: 600; color: var(--ink);
    font-family: 'Vazirmatn', sans-serif; outline: none; transition: border-color 0.2s;
  }
  .f-inp:focus { border-color: var(--gold); }
  .f-inp::placeholder { color: var(--mist); font-weight: 400; }
  .f-group { margin-bottom: 16px; }

  /* ئەپلۆد وێنە */
  .img-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 8px; margin-bottom: 16px; }
  .img-box {
    aspect-ratio: 1; background: var(--cream); border: 1.5px dashed var(--line);
    border-radius: 12px; display: flex; flex-direction: column; align-items: center;
    justify-content: center; cursor: pointer; overflow: hidden; position: relative;
    transition: border-color 0.2s;
  }
  .img-box:hover { border-color: var(--gold); }
  .img-box img { width: 100%; height: 100%; object-fit: cover; display: none; }
  .img-box .img-lbl { font-size: 10px; font-weight: 700; color: var(--mist); margin-top: 4px; }
  .img-box .img-icon { font-size: 20px; opacity: 0.3; }
  .img-box .rm { position: absolute; top: 5px; left: 5px; width: 20px; height: 20px; background: #ef4444; color: #fff; border-radius: 50%; font-size: 13px; font-weight: 900; display: flex; align-items: center; justify-content: center; z-index: 5; }

  /* دووگمەکان */
  .btn-primary {
    width: 100%; padding: 15px; border-radius: 14px;
    background: linear-gradient(135deg, var(--navy) 0%, #1a3a6b 100%);
    color: #fff; font-size: 14px; font-weight: 900;
    font-family: 'Vazirmatn', sans-serif; border: none; cursor: pointer;
    transition: opacity 0.2s, transform 0.1s;
    box-shadow: 0 4px 16px rgba(11,29,58,0.25);
    position: relative; overflow: hidden;
  }
  .btn-primary::after {
    content: ''; position: absolute; top: 0; right: 0; width: 3px; height: 100%;
    background: var(--gold);
  }
  .btn-primary:active { transform: scale(0.98); }
  .btn-primary:disabled { opacity: 0.5; }
  .btn-ghost {
    width: 100%; padding: 12px; border-radius: 14px; background: transparent;
    border: 1.5px solid var(--line); color: var(--mist);
    font-size: 12px; font-weight: 700; font-family: 'Vazirmatn', sans-serif;
    cursor: pointer; margin-top: 10px;
  }

  /* ── مۆدالی دیتایل ── */
  .detail-modal {
    position: fixed; inset: 0; background: #fff;
    display: none; flex-direction: column; z-index: 150;
  }
  .detail-modal.open { display: flex; }
  .detail-scroll { flex: 1; overflow-y: auto; }
  .swiper { width: 100%; height: 300px; }
  .swiper-slide img { width: 100%; height: 100%; object-fit: cover; }
  .swiper-pagination-bullet { background: #fff !important; opacity: 0.6; }
  .swiper-pagination-bullet-active { background: var(--gold) !important; opacity: 1; width: 16px; border-radius: 4px; }
  .detail-body { padding: 28px 24px; }
  .detail-cat { font-size: 10px; font-weight: 700; color: var(--gold); letter-spacing: 0.1em; text-transform: uppercase; margin-bottom: 8px; }
  .detail-name { font-size: 26px; font-weight: 900; color: var(--navy); margin-bottom: 6px; line-height: 1.2; }
  .detail-divider { height: 1px; background: var(--line); margin: 20px 0; }
  .detail-price-wrap { display: flex; align-items: baseline; gap: 6px; margin-bottom: 4px; }
  .detail-price { font-size: 36px; font-weight: 900; color: var(--navy); }
  .detail-currency { font-size: 14px; font-weight: 700; color: var(--gold); }
  .detail-time { font-size: 11px; font-weight: 600; color: var(--mist); }
  .detail-footer { padding: 16px 24px 32px; border-top: 1px solid var(--line); display: flex; flex-direction: column; gap: 10px; background: #fff; }
  .btn-call {
    width: 100%; padding: 15px; border-radius: 14px;
    background: linear-gradient(135deg, var(--gold) 0%, var(--gold-l) 100%);
    color: var(--navy); font-size: 14px; font-weight: 900;
    text-align: center; text-decoration: none; display: block;
    box-shadow: 0 4px 16px rgba(201,168,76,0.3);
  }
  .btn-del {
    width: 100%; padding: 13px; border-radius: 14px;
    background: #fff5f5; color: #dc2626; border: 1.5px solid #fecaca;
    font-size: 13px; font-weight: 700; font-family: 'Vazirmatn', sans-serif;
    cursor: pointer; display: none;
  }
  .btn-back {
    width: 100%; padding: 10px; background: transparent; border: none;
    color: var(--mist); font-size: 12px; font-weight: 700;
    font-family: 'Vazirmatn', sans-serif; cursor: pointer;
  }

  /* ── مۆدالی دڵنیابوونەوە ── */
  .confirm-overlay {
    position: fixed; inset: 0; background: rgba(11,29,58,0.7);
    display: none; align-items: center; justify-content: center; z-index: 200; padding: 24px;
  }
  .confirm-overlay.open { display: flex; }
  .confirm-box { background: #fff; border-radius: 20px; padding: 32px 24px; width: 100%; max-width: 300px; text-align: center; }
  .confirm-icon { font-size: 36px; margin-bottom: 12px; }
  .confirm-t { font-size: 18px; font-weight: 900; color: var(--navy); margin-bottom: 6px; }
  .confirm-m { font-size: 13px; color: var(--mist); font-weight: 500; margin-bottom: 24px; }
  .confirm-btns { display: flex; gap: 10px; }
  .btn-confirm-yes { flex: 1; padding: 13px; background: #dc2626; color: #fff; border: none; border-radius: 12px; font-size: 13px; font-weight: 900; font-family: 'Vazirmatn', sans-serif; cursor: pointer; }
  .btn-confirm-no { flex: 1; padding: 13px; background: var(--cream); color: var(--ink); border: none; border-radius: 12px; font-size: 13px; font-weight: 700; font-family: 'Vazirmatn', sans-serif; cursor: pointer; }

  /* تۆست */
  .toast {
    position: fixed; bottom: 32px; left: 50%; transform: translateX(-50%) translateY(60px);
    background: var(--navy); color: #fff; padding: 13px 26px; border-radius: 14px;
    font-size: 13px; font-weight: 700; z-index: 999; opacity: 0;
    transition: all 0.35s cubic-bezier(.68,-.55,.27,1.55);
    border-right: 3px solid var(--gold); white-space: nowrap;
  }
  .toast.show { opacity: 1; transform: translateX(-50%) translateY(0); }

  /* بووشە */
  .empty-state { grid-column: 1/-1; text-align: center; padding: 60px 0; color: var(--mist); }
  .empty-state .e-icon { font-size: 48px; margin-bottom: 14px; opacity: 0.4; }
  .empty-state p { font-size: 13px; font-weight: 600; }
</style>
</head>
<body>

<div id="toast" class="toast"></div>

<!-- ── هێدەر ── -->
<header class="header">
  <div class="header-inner">
    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:18px;">
      <div class="lang-switch">
        <button class="lang-btn active" id="btn-sorani" onclick="setLang('sorani')">سۆرانی</button>
        <button class="lang-btn" id="btn-badini" onclick="setLang('badini')">بادینی</button>
      </div>
    </div>
    <div class="brand">
      <div class="gold-line"><div class="gold-dot"></div></div>
      <div class="brand-sub" id="brand-sub">KURDISTAN MARKETPLACE</div>
      <div class="brand-name">S<span>-</span>MARKET</div>
    </div>
    <div class="search-wrap">
      <input type="text" id="searchInp" class="search-inp" onkeyup="renderData()">
      <button class="add-btn" id="ui-add-btn" onclick="openModal()"></button>
    </div>
  </div>
</header>

<!-- کاتیگۆری -->
<div class="cat-strip" id="catList"></div>

<!-- گرید -->
<div class="grid-wrap" id="grid"></div>

<!-- ── مۆدالی زیادکردن ── -->
<div class="overlay" id="addOverlay" onclick="closeModalOutside(event)">
  <div class="sheet">
    <div class="sheet-handle"></div>
    <div class="sheet-title" id="ui-title"></div>
    <div class="f-group">
      <label class="f-label" id="lbl-cat"></label>
      <select class="f-inp" id="pCat"></select>
    </div>
    <div class="f-group">
      <label class="f-label" id="lbl-imgs"></label>
      <div class="img-grid">
        <div class="img-box" id="box1" onclick="document.getElementById('fInp1').click()">
          <div class="img-icon">🖼</div>
          <img id="pImg1"><span class="img-lbl" id="pTxt1">وێنە ١</span>
        </div>
        <div class="img-box" id="box2" onclick="document.getElementById('fInp2').click()">
          <div class="img-icon">🖼</div>
          <img id="pImg2"><span class="img-lbl" id="pTxt2">وێنە ٢</span>
        </div>
        <div class="img-box" id="box3" onclick="document.getElementById('fInp3').click()">
          <div class="img-icon">🖼</div>
          <img id="pImg3"><span class="img-lbl" id="pTxt3">وێنە ٣</span>
        </div>
      </div>
      <input type="file" id="fInp1" class="hidden" style="display:none" accept="image/*" onchange="handleImg(event,1)">
      <input type="file" id="fInp2" class="hidden" style="display:none" accept="image/*" onchange="handleImg(event,2)">
      <input type="file" id="fInp3" class="hidden" style="display:none" accept="image/*" onchange="handleImg(event,3)">
    </div>
    <div class="f-group">
      <label class="f-label" id="lbl-name"></label>
      <input type="text" class="f-inp" id="pName">
    </div>
    <div class="f-group">
      <label class="f-label" id="lbl-price"></label>
      <input type="number" class="f-inp" id="pPrice" style="color:#0B1D3A;font-weight:900;">
    </div>
    <div class="f-group">
      <label class="f-label" id="lbl-phone"></label>
      <input type="tel" class="f-inp" id="pPhone">
    </div>
    <button class="btn-primary" id="ui-submit" onclick="submitPost()"></button>
    <button class="btn-ghost" id="ui-close" onclick="closeModal()"></button>
  </div>
</div>

<!-- ── مۆدالی دیتایل ── -->
<div class="detail-modal" id="detailModal">
  <div class="detail-scroll">
    <div class="swiper mySwiper">
      <div class="swiper-wrapper" id="sliderWrapper"></div>
      <div class="swiper-pagination"></div>
    </div>
    <div class="detail-body" id="detailBody"></div>
  </div>
  <div class="detail-footer">
    <a id="callBtn" href="" class="btn-call"></a>
    <button id="delBtn" class="btn-del" onclick="openConfirm()"></button>
    <button class="btn-back" id="ui-back" onclick="closeDetail()"></button>
  </div>
</div>

<!-- ── مۆدالی دڵنیابوونەوە ── -->
<div class="confirm-overlay" id="confirmOverlay">
  <div class="confirm-box">
    <div class="confirm-icon">🗑</div>
    <div class="confirm-t" id="conf-t"></div>
    <div class="confirm-m" id="conf-m"></div>
    <div class="confirm-btns">
      <button class="btn-confirm-yes" id="confirmYes"></button>
      <button class="btn-confirm-no" id="confirmNo" onclick="closeConfirm()"></button>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
<script>
  // ── داتا و ستەیت ──
  let lang = 'sorani', cat = 'هەمووی', currentImgs = ['','',''], swiperInst = null, isSubmitting = false, pendingDeleteId = null;

  function genId() { return `${Date.now()}-${Math.random().toString(36).substr(2,7)}`; }
  const myId = localStorage.getItem('uid') || (() => { const id = genId(); localStorage.setItem('uid', id); return id; })();

  let posts = JSON.parse(localStorage.getItem('s_posts') || '[]');
  function savePosts() { localStorage.setItem('s_posts', JSON.stringify(posts)); }

  const dict = {
    sorani: {
      sub: 'KURDISTAN MARKETPLACE', add: 'بڵاوکردنەوە +', search: 'بگەڕێ بۆ کاڵاکان...',
      title: 'بڵاوکردنەوەی نوێ', lblCat: 'جۆری کاڵا', lblImgs: 'وێنەی کاڵا',
      lblName: 'ناوی کاڵا', lblPrice: 'نرخ (دۆلار)', lblPhone: 'ژمارەی مۆبایل',
      pName: 'ناوی کاڵا بنووسە...', pPhone: '07XX XXX XXXX',
      submit: 'بڵاوکردنەوە', close: 'داخستن',
      call: '📞 پەیوەندی بکە', del: 'سڕینەوەی ئەم پۆستە',
      back: '← گەڕانەوە',
      confT: 'سڕینەوەی پۆست', confM: 'ئایا دڵنیای؟ ئەم کردارە گەڕانەوەی نییە.',
      yes: 'بەڵێ، بسڕەوە', no: 'نەخێر',
      now: 'ئێستا', min: 'خولەک', hour: 'کاتژمێر', day: 'ڕۆژ',
      empty: 'هیچ کاڵایەک نەدۆزرایەوە',
      errImg: 'تکایە لانیکەم وێنەیەک هەڵبژێرە',
      errFields: 'تکایە هەموو خانەکان پڕ بکەرەوە',
      errPhone: 'ژمارەی تەلەفۆن دروست نییە',
      cats: ['هەمووی','ئۆتۆمبێل','مۆبایل','خانوو','هەمەجۆر'],
      catKeys: ['هەمووی','ئۆتۆمبێل','مۆبایل','خانوو','هەمەجۆر'],
    },
    badini: {
      sub: 'KURDISTAN MARKETPLACE', add: 'بەلاڤکرن +', search: 'لێگەڕیان لە کالاکان...',
      title: 'بەلاڤکرنا نوی', lblCat: 'جۆرێ کالای', lblImgs: 'وێنێ کالای',
      lblName: 'ناڤێ کالای', lblPrice: 'بها (دۆلار)', lblPhone: 'ژمارەی مۆبایل',
      pName: 'ناڤێ کالای بنڤیسە...', pPhone: '07XX XXX XXXX',
      submit: 'بەلاڤکە', close: 'داخستن',
      call: '📞 پەیوەندیێ بکە', del: 'ژێبرنا ئەم پۆستی',
      back: '← زڤڕین',
      confT: 'ژێبرنا پۆستی', confM: 'تۆ یێ پشت راستی؟ ئەم کارێ ناگەرە.',
      yes: 'بەڵێ، ژێببە', no: 'نەخێر',
      now: 'نوکە', min: 'دەقە', hour: 'سەعەت', day: 'ڕۆژ',
      empty: 'هیچ کالایێک نەهات دیتن',
      errImg: 'تکایە لانیکم وێنەیەک هەڵبژێرە',
      errFields: 'تکایە هەموو خانەکان پڕ بکەرەوە',
      errPhone: 'ژمارەی تەلەفۆن دروست نییە',
      cats: ['هەمی','ترومبێل','مۆبایل','خانی','هەمەجۆر'],
      catKeys: ['هەمووی','ئۆتۆمبێل','مۆبایل','خانوو','هەمەجۆر'],
    }
  };

  // ── یارمەتیدەر ──
  function esc(s){ return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;'); }
  function toast(msg, ms=2500){ const t=document.getElementById('toast'); t.innerText=msg; t.classList.add('show'); setTimeout(()=>t.classList.remove('show'),ms); }
  function timeSince(ts){
    const s=Math.floor((Date.now()-ts)/1000), d=dict[lang];
    if(s<60) return d.now;
    if(s<3600) return Math.floor(s/60)+' '+d.min;
    if(s<86400) return Math.floor(s/3600)+' '+d.hour;
    return Math.floor(s/86400)+' '+d.day;
  }

  // ── زمان و UI ──
  function setLang(l){
    lang=l;
    document.getElementById('btn-sorani').className='lang-btn'+(l==='sorani'?' active':'');
    document.getElementById('btn-badini').className='lang-btn'+(l==='badini'?' active':'');
    refreshUI(); renderData();
  }

  function refreshUI(){
    const d=dict[lang];
    document.getElementById('brand-sub').innerText=d.sub;
    document.getElementById('ui-add-btn').innerText=d.add;
    document.getElementById('searchInp').placeholder=d.search;
    document.getElementById('ui-title').innerText=d.title;
    document.getElementById('lbl-cat').innerText=d.lblCat;
    document.getElementById('lbl-imgs').innerText=d.lblImgs;
    document.getElementById('lbl-name').innerText=d.lblName;
    document.getElementById('lbl-price').innerText=d.lblPrice;
    document.getElementById('lbl-phone').innerText=d.lblPhone;
    document.getElementById('pName').placeholder=d.pName;
    document.getElementById('pPhone').placeholder=d.pPhone;
    document.getElementById('ui-submit').innerText=d.submit;
    document.getElementById('ui-close').innerText=d.close;
    document.getElementById('conf-t').innerText=d.confT;
    document.getElementById('conf-m').innerText=d.confM;
    document.getElementById('confirmYes').innerText=d.yes;
    document.getElementById('confirmNo').innerText=d.no;
    document.getElementById('ui-back').innerText=d.back;
    document.getElementById('delBtn').innerText=d.del;

    // کاتیگۆری
    const cl=document.getElementById('catList'); cl.innerHTML='';
    d.cats.forEach((c,i)=>{
      const isAct=cat===d.catKeys[i];
      const btn=document.createElement('button');
      btn.className='cat-btn'+(isAct?' active':'');
      btn.innerText=c;
      btn.onclick=()=>{ cat=d.catKeys[i]; refreshUI(); renderData(); };
      cl.appendChild(btn);
    });

    // سیلێکت
    const sel=document.getElementById('pCat'); sel.innerHTML='';
    d.cats.slice(1).forEach((c,i)=>{
      sel.innerHTML+=`<option value="${d.catKeys[i+1]}">${c}</option>`;
    });
  }

  // ── ڕیندەر ──
  function renderData(){
    const grid=document.getElementById('grid');
    const q=document.getElementById('searchInp').value.toLowerCase();
    const filtered=posts.filter(p=>(cat==='هەمووی'||p.category===cat)&&p.name.toLowerCase().includes(q));
    if(!filtered.length){
      grid.innerHTML=`<div class="empty-state"><div class="e-icon">📦</div><p>${dict[lang].empty}</p></div>`;
      return;
    }
    grid.innerHTML=filtered.map(p=>`
      <div class="card" onclick='showDetail(${JSON.stringify(p).replace(/'/g,"&#39;")})'>
        <div class="card-img">
          <img src="${p.imgs[0]}" loading="lazy" onerror="this.src='data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 1 1%22><rect fill=%22%23f0ece6%22/></svg>'">
          <div class="card-badge">${esc(p.category)}</div>
        </div>
        <div class="card-body">
          <div class="card-name">${esc(p.name)}</div>
          <div class="card-foot">
            <div class="card-price"><span>$</span>${esc(String(p.price))}</div>
            <div class="card-time">${timeSince(p.time)}</div>
          </div>
        </div>
      </div>`).join('');
  }

  // ── دیتایل ──
  function showDetail(p){
    const imgs=p.imgs.filter(Boolean);
    document.getElementById('sliderWrapper').innerHTML=imgs.map(i=>
      `<div class="swiper-slide"><img src="${i}"></div>`).join('');
    document.getElementById('detailBody').innerHTML=`
      <div class="detail-cat">${esc(p.category)}</div>
      <div class="detail-name">${esc(p.name)}</div>
      <div class="detail-divider"></div>
      <div class="detail-price-wrap">
        <div class="detail-price">${esc(String(p.price))}</div>
        <div class="detail-currency">USD</div>
      </div>
      <div class="detail-time">${timeSince(p.time)}</div>`;
    document.getElementById('callBtn').href='tel:'+p.phone;
    document.getElementById('callBtn').innerText=dict[lang].call;
    const db=document.getElementById('delBtn');
    db.style.display=p.owner_id===myId?'block':'none';
    pendingDeleteId=p.id;
    document.getElementById('detailModal').classList.add('open');
    if(swiperInst){swiperInst.destroy(true,true);swiperInst=null;}
    setTimeout(()=>{
      swiperInst=new Swiper('.mySwiper',{
        pagination:{el:'.swiper-pagination',clickable:true},
        autoplay:imgs.length>1?{delay:6000,disableOnInteraction:false}:false,
        loop:imgs.length>1, grabCursor:true,
      });
    },80);
  }
  function closeDetail(){ document.getElementById('detailModal').classList.remove('open'); }

  // ── دڵنیابوونەوە ──
  function openConfirm(){ document.getElementById('confirmOverlay').classList.add('open'); }
  function closeConfirm(){ document.getElementById('confirmOverlay').classList.remove('open'); }
  document.addEventListener('DOMContentLoaded',()=>{
    document.getElementById('confirmYes').onclick=()=>{
      posts=posts.filter(p=>String(p.id)!==String(pendingDeleteId));
      savePosts(); closeConfirm(); closeDetail(); renderData();
      toast('✅ '+dict[lang].del);
    };
  });

  // ── مۆدال ──
  function openModal(){ document.getElementById('addOverlay').classList.add('open'); }
  function closeModal(){
    document.getElementById('addOverlay').classList.remove('open');
    resetForm();
  }
  function closeModalOutside(e){ if(e.target===document.getElementById('addOverlay')) closeModal(); }
  function resetForm(){
    currentImgs=['','',''];
    for(let i=1;i<=3;i++){
      const img=document.getElementById(`pImg${i}`);
      img.style.display='none'; img.src='';
      document.getElementById(`pTxt${i}`).style.display='';
      document.getElementById(`box${i}`).querySelector('.img-icon').style.display='';
      document.getElementById(`fInp${i}`).value='';
      const rm=document.getElementById(`box${i}`).querySelector('.rm');
      if(rm) rm.remove();
    }
    document.getElementById('pName').value='';
    document.getElementById('pPrice').value='';
    document.getElementById('pPhone').value='';
  }

  // ── وێنە ──
  function compressImage(file,maxW=800,q=0.78){
    return new Promise(res=>{
      const r=new FileReader();
      r.onload=e=>{
        const img=new Image();
        img.onload=()=>{
          const c=document.createElement('canvas');
          let w=img.width,h=img.height;
          if(w>maxW){h=Math.round(h*maxW/w);w=maxW;}
          c.width=w;c.height=h;
          c.getContext('2d').drawImage(img,0,0,w,h);
          res(c.toDataURL('image/jpeg',q));
        };
        img.src=e.target.result;
      };
      r.readAsDataURL(file);
    });
  }

  async function handleImg(e,num){
    const file=e.target.files[0]; if(!file) return;
    if(file.size>8*1024*1024){ toast('❌ '+dict[lang].errImg+' (>8MB)'); e.target.value=''; return; }
    const compressed=await compressImage(file);
    currentImgs[num-1]=compressed;
    const img=document.getElementById(`pImg${num}`);
    img.src=compressed; img.style.display='block';
    document.getElementById(`pTxt${num}`).style.display='none';
    document.getElementById(`box${num}`).querySelector('.img-icon').style.display='none';
    const box=document.getElementById(`box${num}`);
    if(!box.querySelector('.rm')){
      const rm=document.createElement('span');
      rm.className='rm'; rm.innerText='×';
      rm.onclick=ev=>{ ev.stopPropagation(); removeImg(num); };
      box.appendChild(rm);
    }
  }

  function removeImg(num){
    currentImgs[num-1]='';
    const img=document.getElementById(`pImg${num}`);
    img.style.display='none'; img.src='';
    document.getElementById(`pTxt${num}`).style.display='';
    document.getElementById(`box${num}`).querySelector('.img-icon').style.display='';
    document.getElementById(`fInp${num}`).value='';
    const rm=document.getElementById(`box${num}`).querySelector('.rm');
    if(rm) rm.remove();
  }

  // ── ناردن ──
  async function submitPost(){
    if(isSubmitting) return;
    const d=dict[lang];
    const name=document.getElementById('pName').value.trim();
    const price=document.getElementById('pPrice').value.trim();
    const phone=document.getElementById('pPhone').value.trim();
    const category=document.getElementById('pCat').value;
    const validImgs=currentImgs.filter(Boolean);
    if(!validImgs.length){ toast(d.errImg); return; }
    if(!name||!price){ toast(d.errFields); return; }
    if(!phone||phone.length<7){ toast(d.errPhone); return; }
    isSubmitting=true;
    document.getElementById('ui-submit').disabled=true;
    const post={ id:genId(), time:Date.now(), category, name, price, phone, imgs:validImgs, owner_id:myId };
    posts.unshift(post);
    savePosts();
    closeModal();
    toast('✅ بڵاوکرایەوە!');
    renderData();
    isSubmitting=false;
    document.getElementById('ui-submit').disabled=false;
  }

  // ── دەستپێکردن ──
  setLang('sorani');
</script>
</body>
</html>
