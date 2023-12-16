local function print_msg(msg)
  P { msg = msg }
end

return {
  setup = function(opts)
    print_msg(opts.msg)
  end,
}
