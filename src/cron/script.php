<?php

$content = date('Y-m-d H:i:s') . ' - ' . 'Script Cron Test - ' . uniqid() . "\n";
file_put_contents(__DIR__ . '/file.txt', $content, FILE_APPEND);
