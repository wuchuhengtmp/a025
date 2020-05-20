<?php
namespace Dhc\Models;

class Category extends BaseModel
{
	public $createtime;
	public $icon;
	public $thumb;
	public $id;
	public $pid;
    public function initialize()
    {
        $this->setSource("dhc_article_category");
    }
}
