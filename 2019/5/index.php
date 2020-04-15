<!Doctype html>
<?php
    function parseInstruction($number){
        $op = $number % 100;
        $num_args = 0;
        $arg_types = array();
        $name = "";
        switch ($op) {
            case 1:
                $name = "Add";
                $num_args = 3;
                $arg_types = array(0,0,1);
                break;
            case 2:
                $name = "Mult";
                $num_args = 3;
                $arg_types = array(0,0,1);
                break;
            case 3:
                $name = "Read";
                $num_args = 1;
                $arg_types = array(1);
                break;
            case 4:
                $name = "Write";
                $num_args = 1;
                $arg_types = array(0);
                break;
            case 5:
                $name = "Jump if True";
                $num_args = 2;
                $arg_types = array(0,0);
                break;
            case 6:
                $name = "Jump if False";
                $num_args = 2;
                $arg_types = array(0,0);
                break;
            case 7:
                $name = "Less than";
                $num_args = 3;
                $arg_types = array(0,0,1);
                break;
            case 8:
                $name = "Equals";
                $num_args = 3;
                $arg_types = array(0,0,1);
                break;
            case 99:
                $name = "Halt";
                $num_args = 0;
                break;
            default:
                $name = "Invalid(".$op.")";
                $num_args = 0;
                break;
        }
        $arg_modes = array();
        $modes = intdiv($number, 100);
        for($i = 0; $i < $num_args; $i++){
           $arg_modes[] = $modes % 10;
           $modes = intdiv($modes, 10);
        }
        return array(
            "op" => $op,
            "name" => $name,
            "num_args" => $num_args,
            "arg_types" => $arg_types,
            "arg_modes" => $arg_modes
            );
    }

    function resolveArgs($instr, $program, $ip){
        $resolved_args = array();
        for($i = 0; $i < $instr["num_args"]; $i++){
            if($instr["arg_modes"][$i] || $instr["arg_types"][$i]){
                $resolved_args[] = $program[$ip + $i + 1];
            } else {
                $resolved_args[] = $program[$program[$ip + $i + 1]]; 
            }
        }
        return $resolved_args;
    }

    function executeProg($program, $input){
        $output = array();
        $log = array();
        $ip = 0;
        for($y = 0; $y < 1000; $y++){
            $instr = parseInstruction($program[$ip]);
            $args = resolveArgs($instr, $program, $ip);
            $code = array_slice($program, $ip, $instr["num_args"] + 1);
            $addr = $ip;
            $ip = $ip + $instr["num_args"] + 1;
            switch ($instr["op"]) {
                case 1:
                    $program[$args[2]] = $args[0] + $args[1];
                    break;
                case 2:
                    $program[$args[2]] = $args[0] * $args[1];
                    break;
                case 3:
                    $in = array_shift($input);
                    if($in === NULL){
                        $in = 0;
                    }
                    $program[$args[0]] = $in;
                    $arg_log = array($dest);
                    break;
                case 4:
                    $output[] = $args[0];
                    break;
                case 5:
                    if($args[0]){
                        $ip = $args[1];   
                    }
                    break;
                case 6:
                    if(!$args[0]){
                        $ip = $args[1];   
                    }
                    break;
                case 7:
                    if($args[0] < $args[1]){
                        $program[$args[2]] = 1;
                    } else {
                        $program[$args[2]] = 0;
                    }
                    break;
                case 8:
                    if($args[0] === $args[1]){
                        $program[$args[2]] = 1;
                    } else {
                        $program[$args[2]] = 0;
                    }
                    break;
                case 99:
                    $log[] = array($addr, $code, $instr, $args);
                    return array($output, $log, $program, "<span style='color: #22bb45'>Success</span>");
                default:
                    $log[] = array($addr, $code, $instr, $args);
                    return array($output, $log, $program, "<span style='color: #CC0000'>Invalid Instruction</span>");
                    break;
            }
            $log[] = array($addr, $code, $instr, $args);
        }
        return array($output, $log, $program, "<span style='color: #CC0000'>Time Out</span>");
    }

    function parseLogEntry($log_entry){
        $addr = $log_entry[0];
        $code = $log_entry[1];
        $instr = $log_entry[2];
        $args = $log_entry[3];
        $modes = array_map(function($item){ if($item) { return "$"; } else { return "*"; } }, $instr["arg_modes"]);
        $op = "";
        $arg_str = "";
        switch ($instr["op"]) {
            case 1:
                $arg_str = $modes[0].$args[0]." + ".$modes[1].$args[1]." -> *".$args[2];
                break;
            case 2:
                $arg_str = $modes[0].$args[0]." * ".$modes[1].$args[1]." -> *".$args[2];
                break;
            case 3:
                $arg_str = "-> *".$args[0];
                break;
            case 4:
                $arg_str = "<- ".$modes[0].$args[0];
                break;
            case 5:
                $arg_str = $modes[0].$args[0]."? -> ".$modes[1].$args[1];
                break;
            case 6:
                $arg_str = "!(".$modes[0].$args[0].")? -> ".$modes[1].$args[1];
                break;
            case 7:
                $arg_str = $modes[0].$args[0]." < ".$modes[1].$args[1]."? 1-> *".$args[2];
                break;
            case 8:
                $arg_str = $modes[0].$args[0]." == ".$modes[1].$args[1]."? 1-> *".$args[2];
                break;
            case 99:
                break;
            default:
                $op = "Invalid(".$instr["op"].")";
                $arg_str = join(",", $args);
                break;
        }
        return array($addr, join(",",$code), $instr["name"].": ".$arg_str);
    }
    
    $input_prog = file_get_contents("input.txt");
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $input = array();
        $program = array(99);
        if($_POST["input"]){
            $input = array_map('intval', explode("\n", $_POST["input"]));
        }
        if($_POST["program"]){
            $program = array_map('intval', explode(",", preg_replace('/\s+/', '', $_POST["program"])));
            $input_prog = $_POST["program"];
        }
        $ret = executeProg($program, $input);
        $output = $ret[0];
        $log = $ret[1];
        $final_state = $ret[2];
        $exit_state = $ret[3];
    }
?>

<html>
    <body>
        <h1>Advent of Code - Day 5</h1>
        <div style="display: flex">
            <div style="width: 50%";>
                <form action="" method="POST">
                    <label for="program">Program:</label>
                    <br>
                    <textarea name="program" id="program" rows="10" style="width: 90%"><?php echo $input_prog; ?></textarea>
                    <br>
                    <label for="input">Input for program (Each line for one input):</label>
                    <br>
                    <textarea name="input" id="input" rows="3" style="width: 90%"><?php echo $_POST["input"]; ?></textarea>
                    <br>
                    <button type="submit">Send!</button>
                </form>
            </div>
            <div style="width: 50%;";>
                <h3>Final State:</h3>
                <textarea rows="10" style="width: 90%"><?php echo join(",", $final_state); ?></textarea>
                <p>Exit status: <?php echo $exit_state; ?></p>
                <div style="display: flex;">
                    <div style="width: 40%";>
                    <h3>Output:</h3>
                        <ul>
                            <?php 
                                array_map(function($value){echo "<li>".$value."</li>";}, $output);
                            ?>
                        </ul>
                    </div>
                    <div style="width: 50%";>                
                        <h3>Log:</h3>
                        <ul>
                            <li>$x: x is an immediate value</li>
                            <li>*x: x is loaded from address</li>
                        </ul>
                        <table style="width:100%">
                            <tr style="text-align: left">
                                <th>Addr</th>
                                <th>Code</th>
                                <th>Instruction</th>
                            </tr>
                            
                            <?php 
                                array_map(function($value){
                                    echo "<tr>";
                                    $parsed_entry = parseLogEntry($value);
                                    echo "<td>".$parsed_entry[0]."</td>";
                                    echo "<td>".$parsed_entry[1]."</td>";
                                    echo "<td>".$parsed_entry[2]."</td>";
                                    echo "</tr>";
                                }, $log);
                            ?>
                            
                        </table> 
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>