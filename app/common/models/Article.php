<?php
namespace Dhc\Models;

class Article extends BaseModel
{
	public $id;

	public function initialize()
	{
		$this->setSource("dhc_article_list");
	}
}
