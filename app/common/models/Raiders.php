<?php
namespace Dhc\Models;

class Raiders extends BaseModel
{
	public $id;

	public function initialize()
	{
		$this->setSource("dhc_article_raiders");
	}
}
