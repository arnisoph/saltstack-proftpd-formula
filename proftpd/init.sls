#!jinja|yaml

{% from 'proftpd/defaults.yaml' import rawmap_osfam with context %}
{% set datamap = salt['grains.filter_by'](rawmap_osfam, merge=salt['grains.filter_by'](rawmap_os|default({}), grain='os', merge=salt['pillar.get']('proftpd:lookup'))) %}

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
