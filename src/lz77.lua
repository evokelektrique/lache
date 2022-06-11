LZ77 = {
   window = "",
   output = {},
   max_offset = 2048,
   max_length = 32,
}

LZ77.__index = LZ77

LZ77.new = function(self, input)

   local input_array = input
   local search = self:best_length_offset(input_array)

   while #input_array > 0 do
      table.insert(
         self.output,
         { search.offset, search.length, string.sub(input_array, 1, 1) }
      )
      self.window = self.window .. string.sub(input_array, #input_array, search.length)
      input_array = string.sub(input_array, search.length)
      -- print(search.length)
   end

   return setmetatable({}, LZ77)
end

LZ77.best_length_offset = function(self, input)
   local window = ""
   local max_length = 16
   local max_offset = 4096
   local cut_window = window

   if max_offset < #window then
      cut_window = string.sub(window, -max_offset)
   end

   if input == nil or input == "" then
      return {0, 1}
   end

   local length = 1
   local offset = 0

   local match = string.find(cut_window, string.sub(input, 1, 1))
   if match then
      local best_length = self:repeating_length_from_start(
         string.sub(input, 1, 1),
         string.sub(input, 1)
      )

      length = length + best_length

      return {
         math.min(length, max_length),
         offset
      }
   end

   length = 0

   for index = 1, string.len(cut_window) + 1 do
      local char = string.sub(cut_window, -index, -index)

      if char == string.sub(input, 1, 1) then
         local found_offset = index
         local found_length = self:repeating_length_from_start(
            string.sub(cut_window, -index), input
         )

         if found_length > length then
            length = found_length
            offset = found_offset
         end
      end
   end

   return {
      length = math.min(length, max_length),
      offset = offset
   }
end

LZ77.repeating_length_from_start = function(self, window, input)
   if window == "" or input == "" then
      return 0
   end

   if string.sub(window, 1, 1) == string.sub(input, 1, 1) then
      return 1 + self:repeating_length_from_start(
         string.sub(window, 1) + string.sub(input, 1, 1),
         string.sub(input, 1)
      )
   end

   return 0
end

-- a = LZ77:new("test test abc")
-- require 'pl.pretty'.dump(a.output)
