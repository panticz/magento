#!/usr/bin/php
<?php
if(count($_SERVER['argv']) > 1) {
    $value=$_SERVER['argv'][1];
    
    require '/var/www/app/Mage.php';
    Mage::app(0);

    $config = new Mage_Core_Model_Config();
    $config->saveConfig('carriers/flatrate/active', $value, 'default', 0);
    $config->saveConfig('carriers/matrixrate/active', !$value, 'default', 0);

    Mage::app()->getCacheInstance()->cleanType('config');
} else {
    echo "Usage: " . $_SERVER['argv'][0] . " 0|1\n";
}
?>
