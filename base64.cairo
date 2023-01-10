

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import signed_div_rem, unsigned_div_rem
from starkware.cairo.common.math_cmp import is_nn


const BASE64_EXTEND = '=';
const BASE64_LEN = 64;

func base64_encode{range_check_ptr}(input_array: felt*, input_len) -> (felt*, felt) {
    alloc_locals;
    let (output_array: felt*) = alloc();

    let (_, remainder) = unsigned_div_rem(input_len, 3);
    let (end, _) = unsigned_div_rem(input_len + 2, 3);
    let base64_array = init_base64_array();
    return compute_encode(input_array, 0, remainder, end, output_array, 0, base64_array);
}

func base64_decode{range_check_ptr}(input_array: felt*, input_len) -> (felt*, felt) {
    alloc_locals;
    let (output_array: felt*) = alloc();

    let (end, _) = unsigned_div_rem(input_len + 3, 4);
    if (end * 4 - input_len == 2){
        assert input_array[input_len] = BASE64_EXTEND;
        assert input_array[input_len + 1] = BASE64_EXTEND;
    }
    if (end * 4 - input_len == 1){
        assert input_array[input_len] = BASE64_EXTEND;
    }
    let base64_array = init_base64_array();
    return compute_decode(input_array, 0, end, output_array, 0, base64_array, input_len);
}

func compute_encode{range_check_ptr} (input_array: felt*, counter, remainder, end, output_array: felt*, output_len, base64_array: felt*)  -> (felt*, felt) {
    alloc_locals;
    
    if (counter == end) {
        return (output_array, output_len);
    }
    
    if (counter == end - 1){
        if (remainder == 1) {
            tempvar req0 = input_array[counter * 3 + 0];
            tempvar m = req0;
            let (local d0, _) = unsigned_div_rem(m, (2 ** 2));
            let (local d0, _) = unsigned_div_rem(m, (2 ** 2));
            let (local d0, _) = unsigned_div_rem(m, (2 ** 2));
            tempvar n0 = d0;
            tempvar n1 = (m - n0 * 2 ** 2) * 2 ** 4;
            assert output_array[counter * 4 + 0] = base64_array[n0];
            assert output_array[counter * 4 + 1] = base64_array[n1];
            assert output_array[counter * 4 + 2] = BASE64_EXTEND;
            assert output_array[counter * 4 + 3] = BASE64_EXTEND;
            tempvar range_check_ptr = range_check_ptr;
        } else {
            tempvar range_check_ptr = range_check_ptr;
        }

        if (remainder == 2) {
            tempvar req0 = input_array[counter * 3 + 0];
            tempvar req1 = input_array[counter * 3 + 1];
            tempvar m0 = req0 * 2 ** 10;
            tempvar m = m0 + req1 * 2 ** 2;
            tempvar m1 = m;
            tempvar m2 = m;
            
            let (local d0, _) = unsigned_div_rem(m1, (2 ** 12));
            tempvar n0 = d0;
            let (local d1, _) = unsigned_div_rem(m2, (2 ** 6));

            let (local d1, _) = unsigned_div_rem(m2, (2 ** 6));
            tempvar n1 = d1 - n0 * 2 ** 6;
            tempvar n2 = m - n0 * 2 ** 12 - n1 * 2 **6;
            assert output_array[counter * 4 + 0] = base64_array[n0];
            assert output_array[counter * 4 + 1] = base64_array[n1];
            assert output_array[counter * 4 + 2] = base64_array[n2];
            assert output_array[counter * 4 + 3] = BASE64_EXTEND;
            tempvar range_check_ptr = range_check_ptr;
        } else {
            tempvar range_check_ptr = range_check_ptr;
        }

        if (remainder == 0) {
            tempvar req0 = input_array[counter * 3 + 0];
            tempvar req1 = input_array[counter * 3 + 1];
            tempvar req2 = input_array[counter * 3 + 2];

            tempvar m0 = req0 * 2 ** 16;
            tempvar m1 = req1 * 2 ** 8;
            tempvar m2 = req2;
            tempvar m = m0 + m1 + m2;
            
            let (local d0, _) = unsigned_div_rem(m, (2 ** 18));
            tempvar n0 = d0;
            
            let (local d1, _) = unsigned_div_rem(m, (2 ** 12));
            tempvar n1 = d1 - n0 * 2 ** 6;
            

            let (local d2, _) = unsigned_div_rem(m, (2 ** 6));
            tempvar n2 = d2 - n0 * 2 ** 12 - n1 * 2 ** 6;
            
            tempvar n3 = m - n0 * 2 ** 18 - n1 * 2 ** 12 - n2 * 2 ** 6;

            assert output_array[counter * 4 + 0] = base64_array[n0];
            assert output_array[counter * 4 + 1] = base64_array[n1];
            assert output_array[counter * 4 + 2] = base64_array[n2];
            assert output_array[counter * 4 + 3] = base64_array[n3];

            tempvar range_check_ptr = range_check_ptr;
        } else {
            tempvar range_check_ptr = range_check_ptr;
        }
        tempvar range_check_ptr = range_check_ptr;
    } else {

        tempvar req0 = input_array[counter * 3 + 0];
        tempvar req1 = input_array[counter * 3 + 1];
        tempvar req2 = input_array[counter * 3 + 2];

        //compute 3 byte value(3*8bit)
        tempvar m0 = req0 * 2 ** 16;
        tempvar m1 = req1 * 2 ** 8;
        tempvar m2 = req2;
        tempvar m = m0 + m1 + m2;
        
        //compute 4*6 value(4*6bit)
        let (local d0, _) = unsigned_div_rem(m, (2 ** 18));
        tempvar n0 = d0;
        
        let (local d1, _) = unsigned_div_rem(m, (2 ** 12));
        tempvar n1 = d1 - n0 * 2 ** 6;
        

        let (local d2, _) = unsigned_div_rem(m, (2 ** 6));
        tempvar n2 = d2 - n0 * 2 ** 12 - n1 * 2 ** 6;
        
        tempvar n3 = m - n0 * 2 ** 18 - n1 * 2 ** 12 - n2 * 2 ** 6;

        assert output_array[counter * 4 + 0] = base64_array[n0];
        assert output_array[counter * 4 + 1] = base64_array[n1];
        assert output_array[counter * 4 + 2] = base64_array[n2];
        assert output_array[counter * 4 + 3] = base64_array[n3];

        tempvar range_check_ptr = range_check_ptr;
    }

    local new_output_len = output_len + 4;
    
    return compute_encode(input_array, counter + 1, remainder, end, output_array=output_array, output_len=new_output_len, base64_array=base64_array);
}

func compute_decode{range_check_ptr} (input_array: felt*, counter, end, output_array: felt*, output_len, base64_array: felt*, input_len)  -> (felt*, felt) {
    alloc_locals;
    
    if (counter == end) {
        return (output_array, output_len);
    }
    
    let t0 = input_array[counter * 4 + 0];
    let t1 = input_array[counter * 4 + 1];
    let t2 = input_array[counter * 4 + 2];
    let t3 = input_array[counter * 4 + 3];

    let req0 = get_base64_index(t0, BASE64_LEN - 1, base64_array);
    let req1 = get_base64_index(t1, BASE64_LEN - 1, base64_array);
    let req2 = get_base64_index(t2, BASE64_LEN - 1, base64_array);
    let req3 = get_base64_index(t3, BASE64_LEN - 1, base64_array);

    tempvar m0 = req0 * 2 ** 18;
    tempvar m1 = req1 * 2 ** 12;
    local m2;
    local m3;
    local increase_len;

    if (t2 == BASE64_EXTEND) {
        m2 = 0;
        m3 = 0;
        increase_len = 1;
    } else {
        m2 = req2 * 2 ** 6;
        if (t3 == BASE64_EXTEND) {
            m3 = 0;
            increase_len = 2;
        }else {
            m3 = req3;
            increase_len = 3;
        }
    }

    tempvar m = m0 + m1 + m2 + m3;
    
    let (local d0, _) = unsigned_div_rem(m, (2 ** 16));
    tempvar n0 = d0;
    assert output_array[counter * 3 + 0] = n0;

    let (local d1, _) = unsigned_div_rem(m, (2 ** 8));
    tempvar n1 = d1 - n0 * 2 ** 8;
    if (increase_len != 1) {
        assert output_array[counter * 3 + 1] = n1;
    }

    tempvar n2 = m - n0 * 2 ** 16 - n1 * 2 ** 8;
    if (increase_len == 3) {
        assert output_array[counter * 3 + 2] = n2;
    }
    local new_output_len = output_len + increase_len;
    // %{
    //     print("new output len: ", ids.new_output_len)
    //     res = ""
    //     for i in range(ids.new_output_len): 
    //         index = memory[ids.output_array + i]
    //         res += chr(index)

    //     print('decode data: ', res)    
    // %}
    
    return compute_decode(input_array, counter + 1, end, output_array=output_array, output_len=new_output_len, base64_array=base64_array, input_len=input_len);
}


func init_base64_array() -> felt* {
    alloc_locals;
    let (base64_array: felt*) = alloc();
    assert base64_array[0] = 'A';
    assert base64_array[1] = 'B';
    assert base64_array[2] = 'C';
    assert base64_array[3] = 'D';
    assert base64_array[4] = 'E';
    assert base64_array[5] = 'F';
    assert base64_array[6] = 'G';
    assert base64_array[7] = 'H';
    assert base64_array[8] = 'I';
    assert base64_array[9] = 'J';
    assert base64_array[10] = 'K';
    assert base64_array[11] = 'L';
    assert base64_array[12] = 'M';
    assert base64_array[13] = 'N';
    assert base64_array[14] = 'O';
    assert base64_array[15] = 'P';
    assert base64_array[16] = 'Q';
    assert base64_array[17] = 'R';
    assert base64_array[18] = 'S';
    assert base64_array[19] = 'T';
    assert base64_array[20] = 'U';
    assert base64_array[21] = 'V';
    assert base64_array[22] = 'W';
    assert base64_array[23] = 'X';
    assert base64_array[24] = 'Y';
    assert base64_array[25] = 'Z';
    assert base64_array[26] = 'a';
    assert base64_array[27] = 'b';
    assert base64_array[28] = 'c';
    assert base64_array[29] = 'd';
    assert base64_array[30] = 'e';
    assert base64_array[31] = 'f';
    assert base64_array[32] = 'g';
    assert base64_array[33] = 'h';
    assert base64_array[34] = 'i';
    assert base64_array[35] = 'j';
    assert base64_array[36] = 'k';
    assert base64_array[37] = 'l';
    assert base64_array[38] = 'm';
    assert base64_array[39] = 'n';
    assert base64_array[40] = 'o';
    assert base64_array[41] = 'p';
    assert base64_array[42] = 'q';
    assert base64_array[43] = 'r';
    assert base64_array[44] = 's';
    assert base64_array[45] = 't';
    assert base64_array[46] = 'u';
    assert base64_array[47] = 'v';
    assert base64_array[48] = 'w';
    assert base64_array[49] = 'x';
    assert base64_array[50] = 'y';
    assert base64_array[51] = 'z';
    assert base64_array[52] = '0';
    assert base64_array[53] = '1';
    assert base64_array[54] = '2';
    assert base64_array[55] = '3';
    assert base64_array[56] = '4';
    assert base64_array[57] = '5';
    assert base64_array[58] = '6';
    assert base64_array[59] = '7';
    assert base64_array[60] = '8';
    assert base64_array[61] = '9';
    assert base64_array[62] = '+';
    assert base64_array[63] = '/';

    return base64_array;
}

func get_base64_index(value, start, base64_array: felt*) -> felt {
    alloc_locals;
    if (start == 0) {
        return start;
    }
    if (base64_array[start] == value){
        return start;
    }else {
        return get_base64_index(value, start - 1, base64_array);
    }

    
}