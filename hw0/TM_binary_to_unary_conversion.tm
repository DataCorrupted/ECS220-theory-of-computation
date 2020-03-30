states =  {
    start, 
        verify_input, 
            verify_input_zero, 
            verify_input_nonzero,
        init_tapes, 
            init_power_tape,
            init_temp_tape,
        convert_rightmost_bit,
            copy_power_tape_to_output,
                move_power_ptr_rightmost,
            double_power_tape,
                move_power_ptr_leftmost,
                copy_power_to_temp,
                finish_double,                                
        move_output_ptr_leftmost,
    accept, reject
}

input_alphabet =      {0, 1, $}
tape_alphabet_extra = {_}
start_state =         start
accept_state =        accept
reject_state =        reject
num_tapes =           4
delta =
    start                       , $___ -> verify_input               , $___, RSSS;
    start                       , 1___ -> reject                     , 1___, SSSS;
    start                       , 0___ -> reject                     , 0___, SSSS;

    // $$* will be rejected.
    verify_input                , $___ -> reject                     , $___, SSSS;
    verify_input                , 0___ -> verify_input_zero          , 0___, RSSS;
    verify_input                , 1___ -> verify_input_nonzero       , 1___, RSSS;

    // Allow $0_, $0*_ will be rejected.
    verify_input_zero           , ____ -> accept                     , 0___, SSSS;
    verify_input_zero           , 0___ -> reject                     , 0___, SSSS;
    verify_input_zero           , 1___ -> reject                     , 1___, SSSS;
    verify_input_zero           , $___ -> reject                     , 0___, SSSS;

    verify_input_nonzero        , 0___ -> verify_input_nonzero       , 0___, RSSS;
    verify_input_nonzero        , 1___ -> verify_input_nonzero       , 1___, RSSS;
    verify_input_nonzero        , $___ -> reject                     , $___, SSSS;
    verify_input_nonzero        , ____ -> init_tapes                 , ____, SSSS;

    // Init tapes
    init_tapes                  , ____ -> init_power_tape            , _$$$, SRRR;
    init_power_tape             , ____ -> init_temp_tape             , _1__, SRSS;
    init_temp_tape              , ____ -> convert_rightmost_bit      , __1_, LSRS;

    // Start working from rightmost bit
    convert_rightmost_bit       , 0___ -> double_power_tape          , ____, SSLS;
    convert_rightmost_bit       , 1___ -> copy_power_tape_to_output  , ____, SLSS;
    // There is no bit left, we should've done.
    convert_rightmost_bit       , $___ -> move_output_ptr_leftmost   , $___, SSSL;

    // Copy all the 1s in power tape to output tape.
    copy_power_tape_to_output   , _1__ -> copy_power_tape_to_output  , _1_1, SLSR;
    copy_power_tape_to_output   , _$__ -> move_power_ptr_rightmost   , _$__, SRSS;

    // Move power tape pointer back
    move_power_ptr_rightmost    , _1__ -> move_power_ptr_rightmost   , _1__, SRSS;
    move_power_ptr_rightmost    , ____ -> double_power_tape          , ____, SSLS;

    // Now we are about to start next bit, we ought to double the # of 1s in power tape.
    double_power_tape           , __1_ -> double_power_tape          , _11_, SRLS;
    double_power_tape           , __$_ -> move_power_ptr_leftmost    , __$_, SLSS;

    move_power_ptr_leftmost     , _1$_ -> move_power_ptr_leftmost    , _1$_, SLSS;
    move_power_ptr_leftmost     , _$$_ -> copy_power_to_temp         , _$$_, SRRS;
    copy_power_to_temp          , _11_ -> copy_power_to_temp         , _11_, SRRS;
    copy_power_to_temp          , _1__ -> copy_power_to_temp         , _11_, SRRS;
    copy_power_to_temp          , ____ -> convert_rightmost_bit      , ____, LSSS;

    // Accept
    move_output_ptr_leftmost    , $__0 -> move_output_ptr_leftmost   , $__0, SSSL;
    move_output_ptr_leftmost    , $__1 -> move_output_ptr_leftmost   , $__1, SSSL;
    move_output_ptr_leftmost    , $__$ -> accept                     , $__$, SSSR;