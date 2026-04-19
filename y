from flask import Flask, render_template_string, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

all_posts = []

HTML_TEMPLATE = """
<!DOCTYPE html>
<html lang="ku" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>S-MARKET</title>
<script src="https://cdn.tailwindcss.com"></script>
<style>
body { background:#f4f6f8; font-family:sans-serif; margin:0; }

.ocean {
    background: linear-gradient(135deg,#0f172a,#1e40af);
    height:180px;
    border-radius:0 0 40px 40px;
    position:relative;
}

.wave {
    position:absolute;
    bottom:0;
    width:100%;
}

.card {
    background:white;
    border-radius:20px;
    overflow:hidden;
    border:1px solid #eee;
}

.modal {
    background:rgba(255,255,255,0.9);
    backdrop-filter:blur(20px);
    border-radius:30px;
}

.input {
    background:#fff;
    border:1px solid #ddd;
}
</style>
</head>

<body>

<div class="ocean">
<div class="p-6 text-white flex justify-between">
<h1 class="text-2xl font-bold">S-MARKET</h1>
<button onclick="openModal()" class="bg-white text-blue-800 px-4 py-2 rounded-xl text-sm font-bold">زیادکردن</button>
</div>

<svg class="wave" viewBox="0 24 150 28">
<defs>
<path id="w" d="M-160 44c30 0 58-18 88-18s58 18 88 18 58-18 88-18 58 18 88 18 v44h-352z"/>
</defs>
<g>
<use href="#w" x="48" y="0" fill="rgba(255,255,255,0.1)"/>
<use href="#w" x="48" y="3" fill="rgba(255,255,255,0.2)"/>
<use href="#w" x="48" y="5" fill="rgba(255,255,255,0.05)"/>
<use href="#w" x="48" y="7" fill="#f4f6f8"/>
</g>
</svg>
</div>

<div class="p-6">
<input id="search" onkeyup="load()" placeholder="گەڕان..." class="w-full p-4 rounded-xl mb-6 input">

<div id="grid" class="grid grid-cols-2 gap-4"></div>
</div>

<div id="modal" class="fixed inset-0 hidden items-center justify-center bg-black/30">
<div class="modal p-6 w-full max-w-sm">

<input id="name" placeholder="ناو" class="input w-full p-3 rounded-xl mb-3">
<input id="price" placeholder="نرخ" type="number" class="input w-full p-3 rounded-xl mb-3">
<input id="phone" placeholder="ژمارە" class="input w-full p-3 rounded-xl mb-3">
<input id="file" type="file" class="mb-3">

<button onclick="addPost()" class="w-full bg-blue-600 text-white py-3 rounded-xl font-bold">بڵاوکردنەوە</button>
<button onclick="closeModal()" class="w-full mt-2 text-gray-500 text-sm">داخستن</button>

</div>
</div>

<script>

let imgData = ""

function message(t){
    const d=document.createElement("div")
    d.innerText=t
    d.className="fixed bottom-6 left-1/2 -translate-x-1/2 bg-black text-white px-6 py-3 rounded-xl"
    document.body.appendChild(d)
    setTimeout(()=>d.remove(),2000)
}

function openModal(){
    document.getElementById("modal").classList.replace("hidden","flex")
}

function closeModal(){
    document.getElementById("modal").classList.replace("flex","hidden")
}

document.getElementById("file").onchange = e=>{
    const r=new FileReader()
    r.onload=v=> imgData=v.target.result
    r.readAsDataURL(e.target.files[0])
}

async function addPost(){

    const data={
        id:Date.now(),
        name:document.getElementById("name").value,
        price:document.getElementById("price").value,
        phone:document.getElementById("phone").value,
        img:imgData,
        time:Date.now()
    }

    if(!data.name || !data.phone || !imgData){
        return message("زانیاری تەواو نییە")
    }

    await fetch("/api/posts",{
        method:"POST",
        headers:{"Content-Type":"application/json"},
        body:JSON.stringify(data)
    })

    closeModal()
    load()
}

function confirmBox(cb){
    const box=document.createElement("div")
    box.className="fixed inset-0 bg-black/40 flex items-center justify-center"
    box.innerHTML=`
    <div class="bg-white p-6 rounded-2xl text-center w-72">
    <p class="mb-4 font-bold">دڵنیای لە سڕینەوە؟</p>
    <div class="flex gap-2">
    <button id="y" class="flex-1 bg-red-500 text-white py-2 rounded-xl">بەڵێ</button>
    <button id="n" class="flex-1 bg-gray-200 py-2 rounded-xl">نەخێر</button>
    </div>
    </div>`
    document.body.appendChild(box)

    document.getElementById("y").onclick=()=>{cb();box.remove()}
    document.getElementById("n").onclick=()=>box.remove()
}

async function del(id){
    confirmBox(async ()=>{
        await fetch("/api/posts/"+id,{method:"DELETE"})
        load()
    })
}

async function load(){

    const res=await fetch("/api/posts")
    const data=await res.json()
    const q=document.getElementById("search").value.toLowerCase()

    const g=document.getElementById("grid")
    g.innerHTML=""

    data.filter(p=>p.name.toLowerCase().includes(q)).forEach(p=>{
        g.innerHTML+=`
        <div class="card">
        <img src="${p.img}" class="w-full h-40 object-cover">
        <div class="p-3">
        <h3 class="font-bold text-sm">${p.name}</h3>
        <div class="flex justify-between mt-2">
        <span class="text-blue-600 font-bold">$${p.price}</span>
        <button onclick="del(${p.id})" class="text-red-500 text-xs">سڕینەوە</button>
        </div>
        <a href="tel:${p.phone}" class="block text-center mt-3 bg-blue-600 text-white py-2 rounded-xl text-sm">پەیوەندی</a>
        </div>
        </div>`
    })
}

load()

</script>

</body>
</html>
"""

@app.route('/')
def index():
    return render_template_string(HTML_TEMPLATE)

@app.route('/api/posts', methods=['GET'])
def get_posts():
    return jsonify(all_posts)

@app.route('/api/posts', methods=['POST'])
def add_post():
    all_posts.insert(0, request.json)
    return jsonify({"ok": True})

@app.route('/api/posts/<int:id>', methods=['DELETE'])
def delete_post(id):
    global all_posts
    all_posts = [p for p in all_posts if p['id'] != id]
    return jsonify({"deleted": True})

if __name__ == "__main__":
    app
