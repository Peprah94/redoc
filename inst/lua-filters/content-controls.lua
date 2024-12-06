-- This filter takes spans and divs with the the "protected" class
-- and wraps them in XML tags that word will treat as content controls.
-- "Protected" class should have "alias" and "tag" attributes. "id" will be
-- set to an integer automatically.
-- In addition, it may have a "type" attribute, which can be "noedit" (default),
-- "nodelete", "visible", or "none". It may also have a "color" attribute.

function Div(elem)
  -- If any of the elements classes is 'protected' then wrap in content control #TODO, write function to check for any class via looping
  if elem.classes[1] == "protected" then
    -- create local table `sdt` to hold the variables that will be used to construct the ooxml
    local sdt = {}
    local stdOpen
    -- set ID to a random 10-digit integer
    sdt["id"] = tostring(math.random(1000000000, 9999999999))
    sdt["alias"] = "Computed value"
    sdt["tag"] = "cv1"
    sdt["lock"] = "contentLocked"

    return pandoc.List({
        pandoc.RawBlock(
          "openxml",
          '<w:sdt><w:sdtPr>' ..
          '<w:alias w:val="' .. sdt["alias"] .. '"/>' ..
          '<w:tag w:val="' .. sdt["tag"] .. '"/>' ..
          '<w:id w:val="' .. sdt["id"] .. '"/>' ..
          '<w:lock w:val="' .. sdt["lock"] .. '"/>' ..
--         '<w15:color w:val="' .. sdt["color"] .. '"/>' ..  -- TODO:docx produced by pandoc does not have w15 namespace. Would need to add xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" to the header to make this work.
          '</w:sdtPr><w:sdtContent>'
          ),
        elem,
        pandoc.RawBlock(
          "openxml",
          '</w:sdtContent></w:sdt>'
          )
      })
  else
    return nil
  end
end

function Span(elem)
  if elem.classes[1] == "protected" then
    local sdt = {}
    local stdOpen
    sdt["id"] = tostring(math.random(1000000000, 9999999999))
    sdt["alias"] = "Computed value"
    sdt["tag"] = "cv1"
    sdt["lock"] = "contentLocked"

    return pandoc.List({
        pandoc.RawInline(
          "openxml",
          '<w:sdt><w:sdtPr>' ..
          '<w:alias w:val="' .. sdt["alias"] .. '"/>' ..
          '<w:tag w:val="' .. sdt["tag"] .. '"/>' ..
          '<w:id w:val="' .. sdt["id"] .. '"/>' ..
          '<w:lock w:val="' .. sdt["lock"] .. '"/>' ..
          '</w:sdtPr><w:sdtContent>'
          ),
        elem,
        pandoc.RawInline(
          "openxml",
          '</w:sdtContent></w:sdt>'
          )
      })
  else
    return nil
  end
end
