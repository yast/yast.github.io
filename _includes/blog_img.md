{% capture img_path %}/assets/images/blog/{{ page.date | date: "%Y-%m-%d" }}/{% endcapture %}
{% if include.ext_link %}
[![{{ include.alt }}]({{ img_path | append: include.src | relative_url }}){:
  {{ include.attr }} }]({{ include.ext_link }})
{% elsif include.full_img %}
[![{{ include.alt }}]({{ img_path | append: include.src | relative_url }}){:
  {{ include.attr }} }]({{ img_path | append: include.full_img | relative_url }})
{% else %}
![{{ include.alt }}]({{ img_path | append: include.src | relative_url }}){:
  {{ include.attr }} }
{% endif %}
