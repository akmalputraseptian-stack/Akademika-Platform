<?php

namespace App\Http\Controllers\Api;

use OpenApi\Attributes as OA;

#[OA\Info(title: "Akademika API", version: "1.0.0", description: "API documentation for Akademika Students Management")]
#[OA\Server(url: "/api", description: "Main API Server")]
class Swagger
{
}
