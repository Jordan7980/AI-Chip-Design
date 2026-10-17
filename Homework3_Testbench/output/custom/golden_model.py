def priority_encoder8_golden(req):
    idx = 0
    valid = 0
    for i in range(7, -1, -1):
        if req & (1 << i):
            idx = i
            valid = 1
            break
    return {'idx': idx, 'valid': valid}