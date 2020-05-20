
<div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
    {% for row in articleList %}
	 <div class="panel panel-default">
        <div class="panel-heading" role="tab" id="heading{{ row.id }}">
          <h4 class="panel-title">
            <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse{{ row.id }}" aria-expanded="true" aria-controls="collapse{{ row.id }}">
              {{ row.title }}
            </a>
          </h4>
        </div>
        <div id="collapse{{ row.id }}" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading{{ row.id }}">
          <div class="panel-body">
                {{row.content}}
                <p><span class="pull-right"><?php echo date('Y-m-d H:i:s',$row->updateTime)?></span></p>
            </div>
        </div>
      </div>
      {% endfor %}
</div>
