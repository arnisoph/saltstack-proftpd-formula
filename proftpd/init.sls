#!jinja|yaml

{% from 'proftpd/defaults.yaml' import rawmap_osfam with context %}
{% set datamap = salt['grains.filter_by'](rawmap_osfam, merge=salt['pillar.get']('proftpd:lookup')) %}

include: {{ datamap.sls_include|default([]) }}
extend: {{ datamap.sls_extend|default({}) }}

proftpd:
  pkg:
    - installed
    - pkgs: {{ datamap.pkgs }}
  service:
    - running
    - name: {{ datamap.service.name|default('proftpd') }}
    - enable: {{ datamap.service.enable|default(True) }}

{% for i in datamap.config.manage|default([]) %}
  {% set f = datamap.config[i] %}
proftpd_file_{{ i }}:
  file:
    - managed
    - name: {{ f.path }}
    - source: {{ f.template_path|default('salt://proftpd/files/generic') }}
    - mode: {{ f.mode|default(640) }}
    - user: {{ f.user|default('root') }}
    - group: {{ f.group|default('root') }}
    - template: jinja
    - context:
      comp: {{ i }}
    - watch_in:
      - service: proftpd
{% endfor %}

proftpd_passwd:
  file:
    - managed
    - name: {{ datamap.config.passwd.path|default('/etc/proftpd/passwd') }}
    - user: {{ datamap.config.passwd.user|default('proftpd') }}
    - group: {{ datamap.config.passwd.group|default('root') }}
    - mode: {{ datamap.config.passwd.mode|default(460) }}
