#!/bin/bash
# =========================================================
# AgriChem Registry PWA - Full Data Deployment Script
# =========================================================
# Place this script in the same folder as:
# AgriChem_Registry_Explorer.html
# Then run: bash deploy_agrichem.sh
# =========================================================

# Check if the data file exists
if [ ! -f "AgriChem_Registry_Explorer.html" ]; then
    echo "❌ Error: AgriChem_Registry_Explorer.html not found!"
    echo "Please place this script in the same folder as your data file."
    exit 1
fi

echo "📦 Building AgriChem PWA UI..."

# 1. Create the UI HTML file with a placeholder for the data
cat > index.html << 'HTMLEOF'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">
<meta name="theme-color" content="#ffffff">
<meta name="apple-mobile-web-app-capable" content="yes">
<title>AgriChem · Pesticide Registry</title>
<link rel="manifest" href='data:application/manifest+json,{"name":"AgriChem Registry","short_name":"AgriChem","display":"standalone","background_color":"#ffffff","theme_color":"#ffffff","start_url":"./","icons":[{"src":"data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 512 512%22><rect width=%22512%22 height=%22512%22 rx=%2296%22 fill=%22%2316a34a%22/><path d=%22M256 96 C 360 96 416 168 416 264 C 416 376 336 432 256 432 C 200 432 160 392 160 344 C 160 296 200 264 256 264 C 296 264 320 288 320 320%22 fill=%22none%22 stroke=%22%23ffffff%22 stroke-width=%2228%22/><path d=%22M256 152 V 372%22 stroke=%22%23ffffff%22 stroke-width=%2222%22/></svg>","sizes":"any","type":"image/svg+xml"}]}' />
<style>
:root{
  --bg:#f8fafc; --panel:#ffffff; --bg2:#f1f5f9;
  --ink:#0f172a; --ink-dim:#64748b; --line:#e2e8f0;
  --accent:#16a34a; --accent-light:#dcfce7; --accent2:#15803d;
  --red:#dc2626; --red-light:#fee2e2;
  --amber:#d97706; --amber-light:#fef3c7;
  --blue:#2563eb; --blue-light:#dbeafe;
  --purple:#9333ea; --purple-light:#f3e8ff;
  --radius:16px;
  --shadow: 0 4px 6px -1px rgba(0,0,0,0.05), 0 2px 4px -1px rgba(0,0,0,0.03);
  --shadow-hover: 0 10px 15px -3px rgba(0,0,0,0.1), 0 4px 6px -2px rgba(0,0,0,0.05);
}
*{box-sizing:border-box;-webkit-tap-highlight-color:transparent}
html,body{margin:0;padding:0;background:var(--bg);color:var(--ink);
  font:15px/1.45 -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,system-ui,sans-serif;
  -webkit-font-smoothing:antialiased; overscroll-behavior-y:none;}

header.top{position:sticky;top:0;z-index:20;background:var(--panel);
  padding:12px 16px;border-bottom:1px solid var(--line);
  padding-top:max(12px,env(safe-area-inset-top));box-shadow:var(--shadow);}
.brand{display:flex;align-items:center;gap:10px;margin-bottom:12px}
.brand svg{width:30px;height:30px;border-radius:8px;}
.brand h1{font-size:17px;margin:0;font-weight:800;letter-spacing:-.3px;color:var(--ink)}
.brand .sub{font-size:11px;color:var(--ink-dim);font-weight:600}

.search{position:relative;margin-bottom:10px}
.search input{width:100%;background:var(--bg2);border:1px solid var(--line);
  color:var(--ink);padding:12px 12px 12px 40px;border-radius:12px;font-size:14px;font-weight:500;}
.search input:focus{outline:none;border-color:var(--accent);background:#fff}
.search svg{position:absolute;left:12px;top:50%;transform:translateY(-50%);opacity:.5}

.finder{display:flex;gap:8px;margin-bottom:10px}
.finder select{flex:1;background:var(--bg2);border:1px solid var(--line);color:var(--ink);
  padding:10px;border-radius:10px;font-size:13px;font-weight:600;-webkit-appearance:none;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 20 20' fill='%2364748b'%3E%3Cpath fill-rule='evenodd' d='M5.23 7.21a.75.75 0 011.06.02L10 11.06l3.71-3.83a.75.75 0 111.08 1.04l-4.25 4.4a.75.75 0 01-1.08 0L5.21 8.27a.75.75 0 01.02-1.06z' clip-rule='evenodd' /%3E%3C/svg%3E");
  background-repeat:no-repeat;background-position:right 10px center;padding-right:30px;}
.finder-btn{background:var(--accent);color:#fff;border:none;padding:0 16px;border-radius:10px;font-weight:700;cursor:pointer;font-size:13px;}

.chips{display:flex;gap:6px;overflow-x:auto;padding:4px 0 8px;scrollbar-width:none}
.chips::-webkit-scrollbar{display:none}
.chip{flex:0 0 auto;padding:6px 12px;border-radius:999px;font-size:12px;
  background:var(--bg2);color:var(--ink-dim);border:1px solid transparent;cursor:pointer;font-weight:600}
.chip.on{background:var(--accent-light);color:var(--accent2);border-color:var(--accent)}

.view{display:none;padding:16px}
.view.active{display:block}

.stat-grid{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:20px}
.stat-card{background:var(--panel);padding:16px;border-radius:var(--radius);border:1px solid var(--line);box-shadow:var(--shadow)}
.stat-card .icon{width:36px;height:36px;border-radius:10px;display:flex;align-items:center;justify-content:center;margin-bottom:8px}
.stat-card .val{font-size:22px;font-weight:800;color:var(--ink);margin-bottom:2px}
.stat-card .label{font-size:12px;color:var(--ink-dim);font-weight:600}

.chart-card{background:var(--panel);padding:16px;border-radius:var(--radius);border:1px solid var(--line);box-shadow:var(--shadow);margin-bottom:16px}
.chart-title{font-size:14px;font-weight:800;color:var(--ink);margin-bottom:16px;display:flex;align-items:center;gap:6px;}

.bar-chart{display:flex;flex-direction:column;gap:12px}
.bar-row{display:flex;align-items:center;gap:8px}
.bar-label{flex:1;font-size:12px;font-weight:700;color:var(--ink-dim);white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.bar-track{flex:0 0 100px;height:10px;background:var(--bg2);border-radius:6px;overflow:hidden}
.bar-fill{height:100%;border-radius:6px}
.bar-val{flex:0 0 35px;font-size:12px;font-weight:700;text-align:right}

.donut-container{display:flex;align-items:center;justify-content:center;gap:20px}
.donut-svg{transform:rotate(-90deg)}
.donut-legend{display:flex;flex-direction:column;gap:8px}
.legend-item{display:flex;align-items:center;gap:8px;font-size:12px;font-weight:600}
.legend-dot{width:10px;height:10px;border-radius:50%}

.count{padding:0 0 12px;font-size:11px;color:var(--ink-dim);font-weight:600;text-transform:uppercase;letter-spacing:.5px}
.moa-group-header{position: sticky; top: 160px; z-index: 10; background: var(--bg); padding: 8px 4px; margin-top: 12px; font-size: 12px; font-weight: 800; color: var(--accent2); text-transform: uppercase; letter-spacing: .5px; border-bottom: 2px solid var(--accent-light); display: flex; justify-content: space-between; align-items: center;}
.moa-group-header span{font-size:10px;color:var(--ink-dim);font-weight:600;background:#fff;padding:2px 6px;border-radius:4px;border:1px solid var(--line)}

.card{background:var(--panel);border:1px solid var(--line);border-radius:var(--radius);padding:14px;margin-bottom:10px;cursor:pointer;transition:transform .1s, box-shadow .1s}
.card:active{transform:scale(.99);box-shadow:var(--shadow-hover)}
.card .head{display:flex;justify-content:space-between;align-items:flex-start;gap:10px}
.card .trade{font-weight:700;font-size:15px;color:var(--ink);margin-bottom:2px}
.card .common{font-size:12px;color:var(--ink-dim);font-style:italic}
.card .price-tier{font-size:10px;font-weight:700;padding:4px 8px;border-radius:6px;text-align:center}
.tier-red{background:var(--red-light);color:var(--red)}
.tier-amber{background:var(--amber-light);color:var(--amber)}
.tier-green{background:var(--accent-light);color:var(--accent2)}
.tier-slate{background:var(--bg2);color:var(--ink-dim)}

.badges{display:flex;flex-wrap:wrap;gap:5px;margin-top:10px}
.badge{font-size:10px;padding:3px 7px;border-radius:6px;font-weight:700;letter-spacing:.3px;border:1px solid var(--line)}
.b-cat{background:#fff;color:var(--blue);border-color:var(--blue-light)}
.b-moa{background:#fff;color:var(--accent2);border-color:var(--accent-light)}

.meta-grid{display:grid;grid-template-columns:1fr 1fr;gap:10px;margin-top:12px;font-size:12px}
.meta-item{background:var(--bg2);padding:8px 10px;border-radius:8px}
.meta-item .k{font-size:10px;color:var(--ink-dim);text-transform:uppercase;letter-spacing:.4px;margin-bottom:2px;font-weight:700}
.meta-item .v{color:var(--ink);font-weight:600;font-size:12px;word-break:break-word}

.modal{position:fixed;inset:0;background:rgba(0,0,0,0.5);z-index:40;display:none;opacity:0;transition:opacity .2s}
.modal.show{display:block;opacity:1}
.modal .sheet{background:#fff;border-radius:20px 20px 0 0;max-width:600px;margin:0 auto;margin-top:auto;border-top:1px solid var(--line);max-height:92vh;overflow-y:auto;animation: slideUp .25s ease-out;}
@keyframes slideUp { from { transform: translateY(100%); } to { transform: translateY(0); } }
.sheet-head{padding:24px 20px 12px;border-bottom:1px solid var(--line);position:sticky;top:0;background:#fff;z-index:1}
.sheet-head h2{margin:0 0 4px;font-size:20px;font-weight:700}
.sheet-head .sub{font-size:13px;color:var(--ink-dim);font-style:italic}
.sheet-close{position:absolute;top:16px;right:16px;background:var(--bg2);border:none;width:32px;height:32px;border-radius:50%;font-size:18px;cursor:pointer;color:var(--ink-dim)}
.sheet-body{padding:16px 20px 40px}

.detail-section{margin-bottom: 20px; border-bottom: 1px solid var(--line); padding-bottom: 16px; }
.detail-section:last-child{border-bottom:none}
.section-title{font-size:12px; font-weight:800; color:var(--accent2); text-transform:uppercase; letter-spacing:.5px; margin-bottom:12px; display:flex; align-items:center; gap:6px;}
.detail-row{display:flex;justify-content:space-between;padding:8px 0;font-size:13px;gap:10px}
.detail-row .k{color:var(--ink-dim);font-weight:600;flex:0 0 40%}
.detail-row .v{color:var(--ink);font-weight:500;text-align:right;flex:1;word-break:break-word}
.tag-container{display:flex;flex-wrap:wrap;gap:6px;justify-content:flex-end}
.tag{display:inline-block;background:var(--bg2);padding:4px 8px;border-radius:6px;font-size:11px;font-weight:600;color:var(--ink)}

.bottom-nav{position:fixed;bottom:0;left:0;right:0;background:var(--panel);border-top:1px solid var(--line);display:flex;justify-content:space-around;padding:8px 0 max(8px, env(safe-area-inset-bottom));z-index:30}
.nav-btn{background:none;border:none;display:flex;flex-direction:column;align-items:center;gap:2px;font-size:10px;font-weight:700;color:var(--ink-dim);cursor:pointer;padding:4px 12px;border-radius:8px}
.nav-btn.on{color:var(--accent2);background:var(--accent-light)}
.nav-btn svg{width:22px;height:22px}
</style>
</head>
<body>

<header class="top">
  <div class="brand">
    <svg viewBox="0 0 512 512"><rect width="512" height="512" rx="96" fill="#16a34a"/><path d="M256 96 C 360 96 416 168 416 264 C 416 376 336 432 256 432 C 200 432 160 392 160 344 C 160 296 200 264 256 264 C 296 264 320 288 320 320" fill="none" stroke="#fff" stroke-width="28"/><path d="M256 152 V 372" stroke="#fff" stroke-width="22"/></svg>
    <div>
      <h1>AgriChem Registry</h1>
      <div class="sub">DAE Field Guide · Bangladesh</div>
    </div>
  </div>
</header>

<div class="view active" id="view-dashboard">
  <div class="stat-grid">
    <div class="stat-card"><div class="icon" style="background:var(--blue-light);color:var(--blue);"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 7h18M3 12h18M3 17h18"/></svg></div><div class="val" id="stat-products">0</div><div class="label">Registered Products</div></div>
    <div class="stat-card"><div class="icon" style="background:var(--accent-light);color:var(--accent2);"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/></svg></div><div class="val" id="stat-moa">0</div><div class="label">Distinct MoA Groups</div></div>
    <div class="stat-card"><div class="icon" style="background:var(--amber-light);color:var(--amber);"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2a10 10 0 100 20 10 10 0 000-20z M2 12h20"/></svg></div><div class="val" id="stat-crops">0</div><div class="label">Distinct Crops</div></div>
    <div class="stat-card"><div class="icon" style="background:var(--red-light);color:var(--red);"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 9v4M12 17h.01M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/></svg></div><div class="val" id="stat-hhp">0</div><div class="label">Highly Hazardous (HHP)</div></div>
  </div>

  <div class="chart-card">
    <div class="chart-title"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="var(--accent2)" stroke-width="2"><path d="M3 3v18h18M7 16l4-4 4 4 5-5"/></svg>Product Category Distribution</div>
    <div class="bar-chart" id="bar-chart-cats"></div>
  </div>

  <div class="chart-card">
    <div class="chart-title"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="var(--accent2)" stroke-width="2"><path d="M21 12a9 9 0 11-18 0 9 9 0 0118 0z M12 6v6l4 2"/></svg>MoA Coverage Status</div>
    <div class="donut-container">
      <svg class="donut-svg" width="120" height="120" viewBox="0 0 36 36"><circle cx="18" cy="18" r="15.915" fill="none" stroke="#e2e8f0" stroke-width="4"></circle><circle id="donut-fill" cx="18" cy="18" r="15.915" fill="none" stroke="#16a34a" stroke-width="4" stroke-dasharray="0 100" stroke-linecap="round"></circle><text x="18" y="18" text-anchor="middle" dy=".3em" transform="rotate(90 18 18)" font-size="6" font-weight="bold" fill="#0f172a" id="donut-text">0%</text></svg>
      <div class="donut-legend"><div class="legend-item"><div class="legend-dot" style="background:#16a34a"></div>Mapped Products</div><div class="legend-item"><div class="legend-dot" style="background:#e2e8f0"></div>Unmapped (Deliberate)</div></div>
    </div>
  </div>

  <div class="chart-card">
    <div class="chart-title"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="var(--accent2)" stroke-width="2"><path d="M3 3v18h18M7 16l4-4 4 4 5-5"/></svg>Policy Risk Tier Distribution</div>
    <div class="bar-chart" id="bar-chart-tiers"></div>
  </div>

  <div class="chart-card">
    <div class="chart-title"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="var(--accent2)" stroke-width="2"><path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/></svg>Top Active Ingredients (Common Names)</div>
    <div class="bar-chart" id="bar-chart-ingredients"></div>
  </div>

  <div class="chart-card">
    <div class="chart-title"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="var(--accent2)" stroke-width="2"><path d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/></svg>Top Registration Holders</div>
    <div class="bar-chart" id="bar-chart-holders"></div>
  </div>
</div>

<div class="view" id="view-database">
  <div class="search"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="7"/><path d="M21 21l-4-4"/></svg><input id="q-db" type="search" placeholder="Search product, active ingredient, holder..." autocomplete="off"></div>
  <div class="finder"><select id="crop-select-db"><option value="">🌱 All Crops</option></select><select id="pest-select-db"><option value="">🐛 All Pests</option></select><button class="finder-btn" id="find-btn-db">Find</button></div>
  <div class="chips" id="cat-chips-db"></div>
  <div class="count" id="count-db">0 products</div>
  <main id="list-db" style="padding:0 12px 80px"></main>
</div>

<div class="modal" id="detail-modal"><div class="sheet"><div class="sheet-head"><button class="sheet-close" onclick="closeModal()">×</button><h2 id="m-title"></h2><div class="sub" id="m-sub"></div></div><div class="sheet-body" id="m-body"></div></div></div>

<nav class="bottom-nav"><button class="nav-btn on" onclick="switchView('dashboard')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 12l9-9 9 9M5 10v10h14V10"/></svg>Dashboard</button><button class="nav-btn" onclick="switchView('database')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 7h18M3 12h18M3 17h18"/></svg>Database</button></nav>

<script>
// === DATA INJECTED BY SCRIPT ===
const REGISTRY = /* DATA_PLACEHOLDER */;

// === APP LOGIC ===
const R = REGISTRY;
const idx = {}; R.cols.forEach((c,i)=>idx[c]=i);
const rows = R.rows.map(r => {
  return {
    reg: r[idx.reg], cat: r[idx.cat], common: r[idx.common], trade: r[idx.trade],
    moa: r[idx.moa], auth: r[idx.auth], risk: r[idx.risk], tier: r[idx.tier], hhp: r[idx.hhp],
    crops: (r[idx.crops]||[]).map(i => R.crops[i] ?? ('#'+i)), 
    pests: (r[idx.pests]||[]).map(i => R.pests[i] ?? ('#'+i)),
    holder: r[idx.holder] || "Unknown",
    formulation: r[idx.formulation] || "N/A",
    policy_action: r[idx.policy_action] || "Standard"
  };
});

const state = { q:'', cat:'all', cropFilter:'', pestFilter:'' };
const elList = document.getElementById('list-db');
const elCount = document.getElementById('count-db');

function renderDashboard() {
  document.getElementById('stat-products').textContent = rows.length.toLocaleString();
  const distinctMoA = new Set(rows.map(r => r.moa).filter(Boolean)).size;
  document.getElementById('stat-moa').textContent = distinctMoA;
  const distinctCrops = new Set(rows.flatMap(r => r.crops)).size;
  document.getElementById('stat-crops').textContent = distinctCrops;
  const hhpCount = rows.filter(r => String(r.hhp).toUpperCase().includes('YES')).length;
  document.getElementById('stat-hhp').textContent = hhpCount;

  const mappedCount = rows.filter(r => r.moa && r.moa.trim() !== '').length;
  const moaCoverage = ((mappedCount / rows.length) * 100).toFixed(1);
  document.getElementById('donut-fill').setAttribute('stroke-dasharray', `${moaCoverage} 100`);
  document.getElementById('donut-text').textContent = `${moaCoverage}%`;

  const catCounts = {}; rows.forEach(r => { catCounts[r.cat] = (catCounts[r.cat] || 0) + 1; });
  renderBarChart('bar-chart-cats', catCounts, ['var(--blue)', 'var(--accent)', 'var(--amber)', 'var(--purple)', 'var(--red)']);

  const tierCounts = {}; rows.forEach(r => { tierCounts[r.tier] = (tierCounts[r.tier] || 0) + 1; });
  renderBarChart('bar-chart-tiers', tierCounts, ['var(--red)', 'var(--amber)', 'var(--accent)', 'var(--blue)']);

  const ingredientCounts = {}; rows.forEach(r => { ingredientCounts[r.common] = (ingredientCounts[r.common] || 0) + 1; });
  renderBarChart('bar-chart-ingredients', ingredientCounts, ['var(--accent)'], 5);

  const holderCounts = {}; rows.forEach(r => { holderCounts[r.holder] = (holderCounts[r.holder] || 0) + 1; });
  renderBarChart('bar-chart-holders', holderCounts, ['var(--purple)'], 5);
}

function renderBarChart(elementId, dataMap, colors, limit = 0) {
  let entries = Object.entries(dataMap).sort((a, b) => b[1] - a[1]);
  if (limit > 0) entries = entries.slice(0, limit);
  const maxVal = entries.length > 0 ? entries[0][1] : 1;
  let html = ''; let colorIdx = 0;
  entries.forEach(([label, count]) => {
    const pct = (count / maxVal) * 100; const color = colors[colorIdx % colors.length]; colorIdx++;
    html += `<div class="bar-row"><div class="bar-label" title="${label}">${label}</div><div class="bar-track"><div class="bar-fill" style="width:${pct}%;background:${color}"></div></div><div class="bar-val">${count}</div></div>`;
  });
  document.getElementById(elementId).innerHTML = html;
}

function populateDropdowns() {
  const cropSelect = document.getElementById('crop-select-db'); const pestSelect = document.getElementById('pest-select-db');
  const crops = [...new Set(rows.flatMap(r => r.crops))].sort(); const pests = [...new Set(rows.flatMap(r => r.pests))].sort();
  crops.forEach(c => cropSelect.innerHTML += `<option value="${c}">${c}</option>`);
  pests.forEach(p => pestSelect.innerHTML += `<option value="${p}">${p}</option>`);
}
populateDropdowns();

const cats = ['all', ...Array.from(new Set(rows.map(r=>r.cat))).sort()];
const elCatChips = document.getElementById('cat-chips-db');
cats.forEach(c => {
  const b = document.createElement('button'); b.className = 'chip ' + (state.cat===c ? 'on' : ''); b.textContent = c === 'all' ? 'All' : c;
  b.onclick = ()=>{ state.cat=c; document.querySelectorAll('.chip').forEach(ch=>ch.classList.remove('on')); b.classList.add('on'); renderList(); };
  elCatChips.appendChild(b);
});

document.getElementById('q-db').addEventListener('input', e => { state.q = e.target.value.trim().toLowerCase(); renderList(); });
document.getElementById('find-btn-db').addEventListener('click', ()=>{ state.cropFilter = document.getElementById('crop-select-db').value; state.pestFilter = document.getElementById('pest-select-db').value; renderList(); });

function tierClass(tier){ const t = String(tier||'').toUpperCase(); if(t==='RED') return 'tier-red'; if(t==='AMBER') return 'tier-amber'; if(t==='GREEN') return 'tier-green'; return 'tier-slate'; }
function matches(p){
  if(state.cat!=='all' && p.cat!==state.cat) return false;
  if(state.cropFilter && !p.crops.includes(state.cropFilter)) return false;
  if(state.pestFilter && !p.pests.includes(state.pestFilter)) return false;
  if(state.q){ const hay = [p.trade,p.common,p.reg,p.moa,p.cat,p.holder].join(' ').toLowerCase(); if(!hay.includes(state.q)) return false; }
  return true;
}
function esc(s){ return String(s).replace(/[&<>"]/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c])); }

function cardTemplate(p) {
  return `<div class="card" onclick="openModal('${p.reg}')"><div class="head"><div><div class="trade">${esc(p.trade)}</div><div class="common">${esc(p.common)} · ${esc(p.formulation)}</div></div><div class="price-tier ${tierClass(p.tier)}">${esc(p.tier || 'N/A')}</div></div><div class="badges"><span class="badge b-cat">${esc(p.cat)}</span>${p.moa ? `<span class="badge b-moa">${esc(p.moa)}</span>` : ''}</div><div class="meta-grid"><div class="meta-item"><div class="k">Target Crops</div><div class="v">${p.crops.slice(0,3).join(', ')}${p.crops.length>3?` +${p.crops.length-3}`:''}</div></div><div class="meta-item"><div class="k">Target Pests</div><div class="v">${p.pests.slice(0,2).join(', ')}${p.pests.length>2?` +${p.pests.length-2}`:''}</div></div></div></div>`;
}

function renderList(){
  const out = rows.filter(matches);
  elCount.textContent = `${out.length} products found`;
  if(out.length===0){ elList.innerHTML = '<div style="text-align:center;padding:40px;color:#94a3b8;">No products match your filters.</div>'; return; }
  const grouped = {};
  out.forEach(p => { const key = p.moa ? `${p.moa} (${p.auth || 'N/A'})` : 'Unmapped / Unknown MoA'; if(!grouped[key]) grouped[key] = []; grouped[key].push(p); });
  let html = '';
  for(const moaKey in grouped) { html += `<div class="moa-group-header">${moaKey} <span>${grouped[moaKey].length} Products</span></div>`; html += grouped[moaKey].map(cardTemplate).join(''); }
  elList.innerHTML = html;
}

window.openModal = (reg) => {
  const p = rows.find(r => r.reg === reg); if(!p) return;
  document.getElementById('m-title').textContent = p.trade; document.getElementById('m-sub').textContent = `${p.common} · Reg № ${p.reg}`;
  document.getElementById('m-body').innerHTML = `
    <div class="detail-section"><div class="section-title">🏢 Registration Holder</div><div class="detail-row"><div class="k">Company</div><div class="v">${esc(p.holder)}</div></div><div class="detail-row"><div class="k">Formulation</div><div class="v">${esc(p.formulation)}</div></div></div>
    <div class="detail-section"><div class="section-title">🛡️ Resistance & Rotation Management</div><div class="detail-row"><div class="k">MoA Code</div><div class="v">${esc(p.moa||'Unmapped')} (${esc(p.auth||'—')})</div></div><div class="detail-row"><div class="k">Resistance Risk</div><div class="v">${esc(p.risk||'—')}</div></div><div class="detail-row"><div class="k">Rotation Partners</div><div class="v">Rotate with different MoA groups to prevent resistance.</div></div></div>
    <div class="detail-section"><div class="section-title">🌿 Field Application</div><div class="detail-row"><div class="k">Target Crops</div><div class="v tag-container">${p.crops.map(c=>`<span class="tag">${esc(c)}</span>`).join('')}</div></div><div class="detail-row"><div class="k">Target Pests</div><div class="v tag-container">${p.pests.map(c=>`<span class="tag">${esc(c)}</span>`).join('')}</div></div></div>
    <div class="detail-section"><div class="section-title">⚠️ Safety & Compliance</div><div class="detail-row"><div class="k">HHP Status</div><div class="v">${p.hhp && String(p.hhp).toUpperCase().includes('YES') ? 'YES (Highly Hazardous)' : 'No'}</div></div><div class="detail-row"><div class="k">Policy Risk Tier</div><div class="v">${esc(p.tier || 'N/A')}</div></div><div class="detail-row"><div class="k">Policy Action</div><div class="v">${esc(p.policy_action)}</div></div></div>`;
  document.getElementById('detail-modal').classList.add('show');
};
window.closeModal = () => { document.getElementById('detail-modal').classList.remove('show'); };
document.getElementById('detail-modal').addEventListener('click', e => { if(e.target.id === 'detail-modal') closeModal(); });

window.switchView = (view) => {
  document.querySelectorAll('.view').forEach(v => v.classList.remove('active'));
  document.querySelectorAll('.nav-btn').forEach(b => b.classList.remove('on'));
  document.getElementById(`view-${view}`).classList.add('active');
  document.querySelector(`.nav-btn[onclick="switchView('${view}')"]`).classList.add('on');
  window.scrollTo(0, 0);
};

renderDashboard(); renderList();
</script>
</body>
</html>
HTMLEOF

echo "🔄 Extracting full 6,137-row dataset and injecting into PWA..."

# 2. Extract the data using Python and inject it into index.html
python3 << 'PYEOF'
import re
import sys

try:
    with open('AgriChem_Registry_Explorer.html', 'r', encoding='utf-8') as f:
        html = f.read()
    
    # Find the JSON object assigned to window.REGISTRY
    match = re.search(r'window\.REGISTRY\s*=\s*(\{.*?\});', html, re.DOTALL)
    if match:
        data_str = match.group(1)
        
        with open('index.html', 'r', encoding='utf-8') as f:
            app_html = f.read()
            
        # Inject the extracted data into the placeholder
        app_html = app_html.replace('/* DATA_PLACEHOLDER */', data_str)
        
        with open('index.html', 'w', encoding='utf-8') as f:
            f.write(app_html)
            
        print("✅ Full dataset successfully loaded!")
    else:
        print("⚠️ Warning: Could not find REGISTRY data. Using sample data.")
except Exception as e:
    print(f"❌ Error during data extraction: {e}")
    sys.exit(1)
PYEOF

# 3. Start the server and provide the link
PORT=8080
echo "🚀 Starting local server..."
echo "============================================"
echo "👉  OPEN THIS LINK IN YOUR BROWSER:"
echo "    http://localhost:${PORT}"
echo "============================================"
echo "(Press Ctrl+C to stop the server)"

# Try python3, fall back to python if needed
if command -v python3 &>/dev/null; then
    python3 -m http.server $PORT
elif command -v python &>/dev/null; then
    python -m http.server $PORT
else
    echo "❌ Python is not installed. Please install Python to run the server."
fi