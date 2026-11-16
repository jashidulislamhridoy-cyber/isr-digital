/* Loads Recent Work items from Supabase and tells the page to re-render. */
(function () {
  var cfg = window.ISR_SUPABASE || {};
  if (!cfg.url || !cfg.key) return;
  var s = document.createElement("script");
  s.src = "https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2";
  s.onload = function () {
    var sb = window.supabase.createClient(cfg.url, cfg.key);
    sb.from("portfolio_items").select("*").order("position", { ascending: true })
      .then(function (r) {
        if (r.error) { console.error(r.error); return; }
        var out = { YouTube: [], Facebook: [], Instagram: [], Website: [] };
        r.data.forEach(function (row) {
          if (out[row.platform]) out[row.platform].push({
            title: row.title, client: row.client, metric: row.metric, link: row.link, image: row.image_url
          });
        });
        window.ISR_PORTFOLIO = out;
        window.dispatchEvent(new Event("portfolio-ready"));
      });
    sb.from("site_settings").select("key,value").then(function (r) {
      if (r.error) { console.error(r.error); return; }
      var map = {};
      r.data.forEach(function (row) { map[row.key] = row.value; });
      document.querySelectorAll("[data-social]").forEach(function (a) {
        var v = (map[a.dataset.social] || "").trim();
        if (v) { a.href = v; a.target = "_blank"; a.rel = "noopener"; } else { a.style.display = "none"; }
      });
    });
  };
  document.head.appendChild(s);
})();
