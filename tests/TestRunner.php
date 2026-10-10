<?php

class TestRunner
{
    private $passed = 0;
    private $failed = 0;
    private $errors = [];

    public function assert($condition, $message)
    {
        if ($condition) {
            $this->passed++;
            echo "  OK: $message\n";
        } else {
            $this->failed++;
            $this->errors[] = $message;
            echo "  FAIL: $message\n";
        }
    }

    public function assertEqual($expected, $actual, $message)
    {
        $this->assert($expected === $actual, "$message (esperado: " . var_export($expected, true) . ", obtenido: " . var_export($actual, true) . ")");
    }

    public function assertNotEmpty($value, $message)
    {
        $this->assert(!empty($value), $message);
    }

    public function assertArrayHasKey($key, $arr, $message)
    {
        $this->assert(isset($arr[$key]), $message);
    }

    public function summary()
    {
        echo "\n========================================\n";
        echo "Resultados: {$this->passed} OK, {$this->failed} FAIL\n";
        if ($this->failed > 0) {
            echo "Fallos:\n";
            foreach ($this->errors as $e) {
                echo "  - $e\n";
            }
        }
        echo "========================================\n";
        return $this->failed === 0;
    }
}
