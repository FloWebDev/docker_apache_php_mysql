<?php

require __DIR__ . '/AltoRouter.php';

$router = new AltoRouter();

// map homepage
$router->map('GET', '/', function () {
    $var = 0;
    for ($i = 0; $i < 10; $i++) {
        $var++;
    }
    echo 'page index<br>'.$_SERVER["SERVER_PROTOCOL"];
});


$router->map('GET', '/test', function () {
    echo 'page test';
});

$router->map('GET', '/user/[i:id]', function ($id) {
    echo 'user id ' . $id;
});

// match current request url
$match = $router->match();

// call closure or throw 404 status
if (is_array($match) && is_callable($match['target'])) {
    call_user_func_array($match['target'], $match['params']);
} else {
    // no route was matched
    header($_SERVER["SERVER_PROTOCOL"] . ' 404 Not Found');
    echo 404;
}
