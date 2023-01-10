%builtins output range_check

from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.alloc import alloc
from base64 import base64_encode, base64_decode


func main{output_ptr: felt*, range_check_ptr}() {
    alloc_locals;
    let (input_array: felt*) = alloc();
    local input_len;
    %{
        params = program_input["params"]
        print('params & len: ', params, len(params))
        params_len = len(params)
        for i in range(0, params_len): 
            print("params[i]: ", params[i], ord(params[i]))
            memory[ids.input_array + i] = ord(params[i])
        
        ids.input_len = params_len
    %}

    // tempvar counter = input_len;

    // print_loop:
    // tempvar counter = counter - 1;
    // %{
    //     print("input array: ", ids.counter)
    // %}
    // jmp print_loop if counter != 0;
    // let (local encode_value, output_len) = base64_encode(input_array, input_len);
    // %{
    //     encode_result = ""
    //     for i in range(ids.output_len):
    //         encode_result += chr(memory[ids.encode_value + i])
    //     print("encode result: ", encode_result)    
    // %}
    // serialize_word(output_len);
    let (local decode_value, output_len) = base64_decode(input_array, input_len);
    %{
        print('output_len: ', ids.output_len)
        decode_result = ""
        for i in range(ids.output_len):
            decode_result += chr(memory[ids.decode_value + i])
        print("decode result: ", decode_result)    
    %}
    return ();
}