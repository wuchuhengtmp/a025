<?php
namespace Dhc\Modules\Frontend\Controllers;

use Phalcon\Mvc\Controller;

class ControllerBase extends Controller
{
	public function create_salt( $length = '' ) {
		$chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
		$salt = '';
		for ( $i = 0; $i < $length; $i++ )
		{
			$salt .= $chars[ mt_rand(0, strlen($chars) - 1) ];
		}
		return $salt;
	}
}
