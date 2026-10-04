const pages = [...document.querySelectorAll('.page')];
const navItems = [...document.querySelectorAll('.nav-item')];
const title = document.getElementById('pageTitle');
const sidebar = document.getElementById('sidebar');
const labels = {
  overview:'Marketing Overview', meta:'Meta Ads', google:'Google Ads', seo:'SEO Center',
  youtube:'YouTube', content:'Content AI', automation:'Automation', connections:'Connections'
};

function go(section){
  pages.forEach(p=>p.classList.toggle('active',p.id===section));
  navItems.forEach(n=>n.classList.toggle('active',n.dataset.section===section));
  title.textContent=labels[section]||'CPI Marketing Hub';
  sidebar.classList.remove('open');
  window.scrollTo({top:0,behavior:'smooth'});
}
navItems.forEach(n=>n.addEventListener('click',()=>go(n.dataset.section)));
document.querySelectorAll('[data-go]').forEach(b=>b.addEventListener('click',()=>go(b.dataset.go)));
document.getElementById('mobileMenu').addEventListener('click',()=>sidebar.classList.toggle('open'));

const modal = document.getElementById('campaignModal');
document.querySelectorAll('[data-open="campaignModal"]').forEach(b=>b.addEventListener('click',()=>{
  modal.classList.add('show'); modal.setAttribute('aria-hidden','false');
}));
document.querySelectorAll('[data-close]').forEach(b=>b.addEventListener('click',()=>{
  modal.classList.remove('show'); modal.setAttribute('aria-hidden','true');
}));
modal.addEventListener('click',e=>{if(e.target===modal){modal.classList.remove('show');modal.setAttribute('aria-hidden','true')}});

let toastTimer;
function toast(message){
  const el=document.getElementById('toast'); el.textContent=message; el.classList.add('show');
  clearTimeout(toastTimer); toastTimer=setTimeout(()=>el.classList.remove('show'),2600);
}

document.querySelectorAll('.connect-btn').forEach(btn=>btn.addEventListener('click',()=>{
  toast(`${btn.dataset.provider}: UI พร้อมแล้ว — ขั้นต่อไปคือเชื่อม OAuth/API จริงฝั่ง Server`);
}));
document.getElementById('syncBtn').addEventListener('click',()=>toast('Sync จำลองสำเร็จ — ยังไม่มี API credential จริง'));
document.getElementById('saveMockCampaign').addEventListener('click',()=>{
  modal.classList.remove('show'); modal.setAttribute('aria-hidden','true'); toast('บันทึก Campaign Draft จำลองแล้ว');
});
document.getElementById('newRule').addEventListener('click',()=>toast('Rule Builder จะเป็นโมดูลถัดไปหลังเชื่อมข้อมูลจริง'));
document.getElementById('generateContent').addEventListener('click',()=>{
  document.getElementById('draftBox').innerHTML='<b>AI Draft Preview</b><p>ร้านอาหารและคาเฟ่จัดการงานขายให้คล่องขึ้นด้วย CpIPOS — ดูยอดขายแบบเรียลไทม์ เช็กสต๊อก และบริหารหลายสาขาได้จากระบบเดียว พร้อมต่อยอดวัดผลโฆษณาเป็น Lead และ Conversion ใน CPI Marketing Hub</p>';
  toast('สร้าง Draft จำลองแล้ว');
});
document.querySelectorAll('.channel').forEach(b=>b.addEventListener('click',()=>b.classList.toggle('active')));
