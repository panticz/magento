#!/usr/bin/php
<?php
require '/var/www/app/Mage.php';
Mage::app(0);
  
# update configuration
$config = new Mage_Core_Model_Config();
$config->saveConfig('design/footer/copyright', '&copy; ' . date("Y") . ' YOUR COMPANY INC.', 'default', 0);

# refresh cache
Mage::app()->getCacheInstance()->cleanType('config');
sleep(1);
Mage::app()->getCacheInstance()->cleanType('block_html');
?>
