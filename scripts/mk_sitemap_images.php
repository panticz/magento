<?php
require_once '/var/www/html/app/Mage.php';
Mage::app(0);

function print_head() {
    echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
    echo "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n";
}

function print_url($url, $date) {
    echo "<url>\n";
    echo "    <loc>$url</loc>\n";
    echo "    <lastmod>$date</lastmod>\n";
    echo "    <changefreq>monthly</changefreq>\n";
    echo "    <priority>0.3</priority>\n";
    echo "</url>\n";
}

function print_foot() {
    echo "</urlset>\n";
}

try {
    print_head();

    $collection = Mage::getModel('catalog/product')
        ->getCollection()
        ->addAttributeToFilter('image', array('notnull' => '', 'neq' => 'no_selection'))
        ->setStoreId(1);

    foreach($collection as $product) {
        // get last product update
        $updatedAt = substr($product->getUpdatedAt(), 0, 10);

        // get main image
        $image = Mage::getModel('catalog/product_media_config')->getMediaUrl($product->getImage());
        print_url($image, $updatedAt);

        // get additional images
        $gallery = Mage::getModel('catalog/product')->load($product->getId())->getMediaGalleryImages();
        foreach ($gallery as $image) {
            print_url($image->getUrl(), $updatedAt);
        }
    }

    print_foot();
} catch (Exception $e) {
    Mage::printException($e);
}
?>
