

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import signed_div_rem, unsigned_div_rem


func base64_encode{range_check_ptr}(input_array: felt*, input_len) -> (felt*, felt) {
    alloc_locals;
    let (output_array: felt*) = alloc();
    let (base64_array: felt*) = alloc();
    local output_len;

    %{
        base64_params = [
            'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
            'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
            'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
            'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
            'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
            'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
            'w', 'x', 'y', 'z', '0', '1', '2', '3',
            '4', '5', '6', '7', '8', '9', '+', '/'
        ]

        for i in range(0, len(base64_params)):
            memory[ids.base64_array + i] = ord(base64_params[i])
    %}

    
    let (c, remainder) = unsigned_div_rem(input_len, 3);
    tempvar total = c;
    tempvar counter = c;

    compute_loop:

    tempvar counter = counter - 1;
    tempvar base_index = total - counter - 1;
    %{
        print('base_index: ', ids.base_index)
    %}
    tempvar req0 = input_array[base_index * 3 + 0];
    tempvar req1 = input_array[base_index * 3 + 1];
    tempvar req2 = input_array[base_index * 3 + 2];

    //compute 3 byte value(3*8bit)
    tempvar m0 = req0 * 2 ** 16;
    tempvar m1 = req1 * 2 ** 8;
    tempvar m2 = req2;
    tempvar m3 = m0 + m1 + m2;
    
    //compute 4*6 value(4*6bit)
    let (local d0, _) = unsigned_div_rem(m3, (2 ** 18));
    tempvar n0 = d0;
    assert output_array[base_index * 4 + 0] = n0;

    let (local d1, _) = unsigned_div_rem(m3, (2 ** 12));
    tempvar n1 = d1 - n0 * 2 ** 6;
    assert output_array[base_index * 4 + 1] = n1;

    let (local d2, _) = unsigned_div_rem(m3, (2 ** 6));
    tempvar n2 = d2 - n0 * 2 ** 12 - n1 * 2 ** 6;
    assert output_array[base_index * 4 + 2] = n2;

    tempvar n3 = m3 - n0 * 2 ** 18 - n1 * 2 ** 12 - n2 * 2 ** 6;
    assert output_array[base_index * 4 + 3] = n3;

    local range_check_ptr = range_check_ptr;

    %{
        print("input array: ", ids.counter)
        print("req0: ", ids.req0, ids.m0)
        print("req1: ", ids.req1, ids.m1)
        print("req2: ", ids.req2, ids.m2)
        print("m3: ", ids.m3)
        print("------------------------")
        print("n0 r0: ", ids.d0)
        print("n1: ", ids.n1)
        print("n2: ", ids.n2)
        print("n3: ", ids.n3)

        res = base64_params[ids.n0] + base64_params[ids.n1] + base64_params[ids.n2] + base64_params[ids.n3]
        print('base64: ', res)
    %}

    
    jmp compute_loop if counter != 0;

    
    if (remainder == 2) {
        tempvar req0 = input_array[(total - counter - 1) * 3 + 0];
        tempvar req1 = input_array[(total - counter - 1) * 3 + 1];
        tempvar m0 = req0 * 2 ** 8;
        tempvar m1 = req1;
        tempvar m = m0 + m1;

        // local range_check_ptr = range_check_ptr;
        // let (local d0, _) = unsigned_div_rem(m, (2 ** 10));
        // tempvar n0 = d0;
        // assert output_array[(total - counter - 1) * 4 + 0] = n0;
        
        // local range_check_ptr = range_check_ptr;

        // let (local d1, _) = unsigned_div_rem(m, (2 ** 4));
        // tempvar n1 = d1 - n0 * 2 ** 6;
        // assert output_array[(total - counter - 1) * 4 + 1] = n1;

        // local range_check_ptr = range_check_ptr;

    }

    if (remainder == 1) {
        tempvar req0 = input_array[(total - counter - 1) * 3 + 0];

    }

    return (output_array, 4);
}

func base64_decode{range_check_ptr}(input_array: felt*, input_len) -> (felt*, felt) {
    alloc_locals;
    let (output_array: felt*) = alloc();

    tempvar counter = input_len / 4;

    compute_loop:
    tempvar counter = counter - 1;

    tempvar req0 = input_array[counter * 4 + 0];
    tempvar req1 = input_array[counter * 4 + 1];
    tempvar req2 = input_array[counter * 4 + 2];
    tempvar req3 = input_array[counter * 4 + 3];

    //compute 4 byte value(4*6bit)
    tempvar m0 = req0 * 2 ** 18;
    tempvar m1 = req1 * 2 ** 12;
    tempvar m2 = req2 * 2 ** 6;
    tempvar m3 = req3;
    tempvar m = m0 + m1 + m2 + m3;
    
    //compute 3*8 value(3*8bit)
    let (local d0, _) = unsigned_div_rem(m, (2 ** 16));
    tempvar n0 = d0;
    assert output_array[0] = n0;

    let (local d1, _) = unsigned_div_rem(m, (2 ** 8));
    tempvar n1 = d1 - n0 * 2 ** 8;
    assert output_array[1] = n1;


    tempvar n2 = m - n0 * 2 ** 16 - n1 * 2 ** 8;
    assert output_array[2] = n2;

    %{
        print("input array: ", ids.counter)
        print("req0: ", ids.req0, ids.m0)
        print("req1: ", ids.req1, ids.m1)
        print("req2: ", ids.req2, ids.m2)
        print("req3: ", ids.req3, ids.m3)
        print("m: ", ids.m)
        print("------------------------")
        print("n0 r0: ", ids.d0)
        print("n1: ", ids.n1)
        print("n2: ", ids.n2)

        res = chr(ids.n0) + chr(ids.n1) + chr(ids.n2)
        print('base64: ', res)
    %}

    jmp compute_loop if counter != 0;

    
    return (output_array, 3);
}

func compute_remainder2{range_check_ptr} (tmp_arr: felt*) {

    return ();
}