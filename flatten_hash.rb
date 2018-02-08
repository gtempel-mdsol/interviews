# programming problem: given this hash, flatten it and encode the keys so
# we can see the hierarchy

hash = { a: { b: { c: 42, d: 'foo' }, d: 'bar' }, e: 'baz' }

# becomes

{ :a_b_c=>42, :a_b_d=>"foo", :a_d=>"bar", :e=>"baz" }


# what are the approach(es) the candidate discusses?


lam = ->(h, key = nil) do
  h.map do |k, v|
    _k = key ? "#{key}_#{k}" : k.to_s
    v.is_a?(Hash) ? lam.call(v, _k) : [_k.to_sym, v]
  end.flatten #⇒ note flatten...taking the resulting map and flattening it 
end
Hash[*lam.call(hash)]

# could implement this as a function, then have the function recurse

# challenge: given the flattened form, reconstruct the nested representation

# https://www.codementor.io/blog/ruby-on-rails-interview-questions-du107w0ss

