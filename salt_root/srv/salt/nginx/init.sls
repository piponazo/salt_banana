
{% from "nginx/map.jinja" import nginx with context %}

install nginx:
  pkg.installed:
    - name: nginx

ensure nginx is running:
  service.running:
    - name: nginx
    - enable: True
    - require:
      - pkg: install nginx

sync index.html:
  file.managed:
    - name: {{ nginx.doc_root }}/index.html
    - source: salt://nginx/files/index.html
    - user: root
    - mode: 644
