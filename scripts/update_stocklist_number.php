#!/usr/bin/php
<?php
require '/var/www/app/Mage.php';
Mage::app(0);

if(count($_SERVER['argv']) == 2) {
  $value = $_SERVER['argv'][1];

  # update magento core config data
  $config = new Mage_Core_Model_Config();
  $config->saveConfig('stocklist/number', $value, 'default', 0);

  # refresh magento configuration cache
  Mage::app()->getCacheInstance()->cleanType('config');
} else {
  echo "Usage: " . $_SERVER['argv'][0] . " LIST_ID\n";
}
?>
