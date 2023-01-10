# cairo-base64
cairo实现base64的编码解码功能

1、base64_encode
    let (local encode_value, output_len) = base64_encode(input_array, input_len);
    %{
        encode_result = ""
        for i in range(ids.output_len):
            encode_result += chr(memory[ids.encode_value + i])
        print("encode result: ", encode_result)    
    %}
2、base64_decode
    let (local decode_value, output_len) = base64_decode(input_array, input_len);
    %{
        print('output_len: ', ids.output_len)
        decode_result = ""
        for i in range(ids.output_len):
            decode_result += chr(memory[ids.decode_value + i])
        print("decode result: ", decode_result)    
    %}


test_input.json
test1:
{
    "params": "{\"alg\":\"ES256K\",\"typ\":\"JWT\"}"
}

test2:
{
    "params": "eyJpc3MiOiJkaWQ6ZG1hc3RlcjoweGU2MDVkZDBiNjYwNzAyRUVFMTdkYmZjRDU2NTQ3MDIzOUM3RTQ0NjQiLCJ2YyI6eyJAY29udGV4dCI6WyJodHRwczovL3d3dy53My5vcmcvMjAxOC9jcmVkZW50aWFscy92MSIsImh0dHBzOi8vd3d3LnczLm9yZy8yMDE4L2NyZWRlbnRpYWxzL2V4YW1wbGVzL3YxIiwiaHR0cHM6Ly93M2lkLm9yZy9zZWN1cml0eS9zdWl0ZXMvZWQyNTUxOS0yMDIwL3YxIl0sImlkIjoiN2YxMGZiYTYtMDhjOS00ZTFkLTlkNmEtZGYzZjUyMzAxZjZiIiwidHlwZSI6WyJNZW1iZXJzaGlwIENhcmQiXSwiaXNzdWVOYW1lIjoiaml0YXNoIiwiaXNzdWVyIjoiZGlkOmRtYXN0ZXI6MHhlNjA1ZGQwYjY2MDcwMkVFRTE3ZGJmY0Q1NjU0NzAyMzlDN0U0NDY0IiwiaXNzdWFuY2VEYXRlIjoiMjAyMy0wMS0wMyIsImV4cGlyYXRpb25EYXRlIjoiTmV2ZXIiLCJjcmVkZW50aWFsU3ViamVjdCI6eyJpc3N1ZURhdGUiOiIyMDIzLTAxLTAzIiwiZXhwaXJlRGF0ZSI6Ik5ldmVyIiwiZXhwaXJlRmxhZyI6MSwiaG9sZGVyIjoiaml0YXNoQGZveG1haWwuY29tIiwiaG9sZGVyX25hbWUiOiJqaXRhc2giLCJjcmVkZW50aWFsX3RpdGxlIjoiamkiLCJNZW1iZXJzaGlwIGxldmVsIjoibGV2ZWwiLCJpZCI6ImRpZDpkbWFzdGVyOjB4ZTYwNWRkMGI2NjA3MDJFRUUxN2RiZmNENTY1NDcwMjM5QzdFNDQ2NCJ9fX0"
}

Command

compile:
cairo-compile test_base64.cairo --output test_base64_compiled.json

run:
cairo-run --program=test_base64_compiled.json --layout=small --print_output --program_input=test_input.json