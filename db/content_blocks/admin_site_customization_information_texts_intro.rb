def content
  '
    <p>All text strings used in your Consul applications are listed on this page. If you\'d like to change any of these strings, you just need to edit it and hit \'Save\' button at the bottom of this page.</p>

    <p>In order to locate the string to edit, invoke the search function of your browser and search for the text that you want to change. In most browsers, you can do that by clicking Ctrl+F (or Cmd+F, if you\'re using a Mac).</p>

    <p>If might encounter several strings with the same text.  It happens when the same text is used in two (or more) locations. In this case just check the key above the text filed containing the string, it will give you a hint as to where this specific string is used. For example, the key proposals.index.featured_proposals indicates that the text in the text field below it, is used to  label featured proposals on proposals index page.</p>
  '
end

if SiteCustomization::ContentBlock.find_by(key: "admin_site_customization_information_texts_intro").nil?
  content_block = SiteCustomization::ContentBlock.new(
    key: 'admin_site_customization_information_texts_intro',
    name: 'custom',
    locale: 'de',
    body: content
  )
  content_block.save!
end
