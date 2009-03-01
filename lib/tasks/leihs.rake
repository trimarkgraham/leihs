namespace :leihs do
  
  desc "Initialize"
  task :init => :environment do
    params = {:all => ENV['items']}
    create_some(params)
  end
  
  desc "Migration from leihs1 - items that are not in ithelp and users in general"
  task :init_once => :environment do
    create_once
  end
  
  desc "Migrate reservations from leihs1"
  task :import_reservations => :environment do
    params = { :pool => ENV['pool']}
    import_reservations(params)
  end
  
  desc "Maintenance: rebuild ferret index"
  task :maintenance => :environment do
    
    puts "Rebuilding ferret index..."
    User.rebuild_index
    Role.rebuild_index
    Category.rebuild_index
    Template.rebuild_index
    Model.rebuild_index
    Item.rebuild_index
    InventoryPool.rebuild_index
    Location.rebuild_index
    Contract.rebuild_index
    Order.rebuild_index
    Option.rebuild_index
    
    puts "Maintenance complete ------------------------"    
  end

  desc "Remind users"
  task :remind => :environment do
    puts "Reminding users..."    
    User.remind_all

    puts "Remind complete -----------------------------"    
  end

  desc "Deadline soon reminder" 
  task :deadline_soon_reminder => :environment do
    puts "Sending a deadline soon reminder..."
    User.send_deadline_soon_reminder_to_everybody
    puts "Deadline soon reminded ----------------------"
  end
  
  desc "Cron: Remind & Maintenance"
  task :cron => [:remind, :maintenance, :deadline_soon_reminder]

  desc "Run Rspec tests"
  task :test do
    puts "Removing log/test.log..."
      system "rm log/test.log"
    puts "Resetting database..."
      system "rake db:migrate:reset RAILS_ENV=test"
    puts "Running all stories..."
      system "ruby stories/all.rb"
  end


  # TODO remove this
  desc "Random dataset generator"
  task :dataset => :environment do
#    params[:id] = 5
#    params[:name] = "admin"
#    create_some_users
#    params[:name] = "customer"
#    create_some_users

    create_meaningful_users

#temp#    create_some_submitted_orders(10)
    
#    create_beautiful_order
#    scene_3a
#    scene_3b

    puts "Complete"    
  end
  
################################################################################################
# Refactoring from Backend::TemporaryController

  def create_once
    puts "Importing from leihs 1"
    Importer.new.start_once
    puts "Done"
  end
  
  def import_reservations(params = {})
    puts "Importing Reservations"
    Importer.new.start_reservations_import(params[:pool].to_i)
    puts "Done"
  end
  
  def create_some(params = {})
    puts "Initializing #{params[:all]} items ..."
    
#old#    reset_session
#    clean_db_and_index
    
    params[:id] = 3
    params[:name] = "model"
#    if params[:all]
      max = params[:all].to_i
      if max > 0
        Importer.new.start(max)
      else
        Importer.new.start
      end
#    else
#      create_meaningful_inventory
#    end
    
   # create_some_categories
    create_some_root_categories
#old#    create_some_packages
#    create_some_templates

#    create_some_properties
#    create_some_compatibles
#    create_some_accessories
    
    puts "Complete"
  end


#  def scene_3a
#    u = User.find_by_login("Franco Sellitto")
#    
#    order = u.get_current_order
#    start_date = Date.new(2008, 7, 15)
#    end_date = Date.new(2008, 8, 4)
#
#    m1 = u.inventory_pools.find_by_name("AVZ").models.find_by_name("HDV/DVCam-Kamera Sony HVR-Z1E")
#    order.add_line(2, m1, u.id, start_date, end_date )
#    m2 = u.inventory_pools.find_by_name("AVZ").models.find_by_name("LCD Monitor Panasonic BT-LH900AE")
#    order.add_line(1, m2, u.id, start_date, end_date )
#    m3 = u.inventory_pools.find_by_name("AVZ").models.find_by_name("Stativ Velbon TH650 Admiral")
#    order.add_line(2, m3, u.id, start_date, end_date )
#
#    start_date = Date.new(2008, 8, 4)
#    end_date = Date.new(2008, 10, 1)
#    m1 = u.inventory_pools.find_by_name("AVZ").models.find_by_name("PC Siemens Celsius W340, P4 3.2GHz 1GB")
#    order.add_line(1, m1, u.id, start_date, end_date )
#    m2 = u.inventory_pools.find_by_name("AVZ").models.find_by_name("HD LaCie d2 Drive 250 GB")
#    order.add_line(1, m2, u.id, start_date, end_date )
#
#    order.purpose = "Filming Scarface 2"
#    output1 = order.submit
#
#    ######
#        
#    u = User.find_by_login("Ramon Cahenzli")
#
#    order = u.get_current_order
#    start_date = Date.new(2008, 7, 15)
#    end_date = Date.new(2008, 7, 25)
#
##old#
##    p1 = u.inventory_pools.find_by_name("AVZ").packages.find_by_name("Stereo Set")
##    p1.add_to_document(order, u.id, 1, start_date, end_date)
#    
#    m2 = u.inventory_pools.find_by_name("AVZ").models.find_by_name("Digitalrecorder Edirol R-1")
#    m2.add_to_document(order, u.id, 1, start_date, end_date)
# 
#    start_date = Date.new(2008, 7, 25)
#    end_date = Date.new(2008, 8, 4)
#    m1 = u.inventory_pools.find_by_name("AVZ").models.find_by_name("PC Siemens Celsius W340, P4 3.2GHz 1GB")
#    m1.add_to_document(order, u.id, 1, start_date, end_date)
#    m2 = u.inventory_pools.find_by_name("AVZ").models.find_by_name("Aktivboxen Sony SRS-Z750")
#    m2.add_to_document(order, u.id, 4, start_date, end_date)
#    
#    order.purpose = "Recording CD"
#    output2 = order.submit
#    
#    puts "#{output1} - #{output2}"
#  end
#
#   def scene_3b
#    u = User.find_by_login("Ramon Cahenzli")
#
#    order = u.get_current_order
#    start_date = Date.new(2008, 9, 1)
#    end_date = Date.new(2008, 10, 2)
#
##old#
##    p1 = u.inventory_pools.find_by_name("AVZ").packages.find_by_name("Stereo Set")
##    p1.add_to_document(order, u.id, 1, start_date, end_date)
#    
#    m2 = u.inventory_pools.find_by_name("AVZ").models.find_by_name("Digitalrecorder Edirol R-1")
#    m2.add_to_document(order, u.id, 1, start_date, end_date)
#     
#    order.purpose = "Recording CD (one more time)"
#    output1 = order.submit
#    
#    puts "#{output1}"
#  end
 
  
  
################################################################################################
  
  
#  def create_some_inventory
#    params[:id].to_i.times do |i|
#      m = Model.new(:name => params[:name] + " " + i.to_s)
#      m.save
#      5.times do |serial_nr|
#        i = Item.new(:model_id => m.id, :inventory_code => Item.get_new_unique_inventory_code)
#      
#        i.save
#      end
#    end
#  end


#old# 
#  def create_some_packages
#    ip = InventoryPool.find_by_name("AVZ")
#    p = Package.create(:name => "Stereo Set", :inventory_pool => ip)
#
#      m = ip.models.find_by_name("Mikrophon Sony Bluetooth ECM-HW1R")
#      p.model_links << ModelLink.create(:model => m, :quantity => 1)
#  
#      m = ip.models.find_by_name("Mikrophon Hama RMZ-14")
#      p.model_links << ModelLink.create(:model => m, :quantity => 1)
#
#    c = Category.find_by_name("Mikrofon")
#    add_to(c, p)
#  end

  def create_some_templates
    p = Template.create(:name => "Interview Set")

      m = Model.find_by_name("DV-Kamera Sony-HC85E")
      p.model_links << ModelLink.create(:model => m, :quantity => 1)

      m = Model.find_by_name("Video-Stativ Sachtler DA 75")
      p.model_links << ModelLink.create(:model => m, :quantity => 1)

      m = Model.find_by_name("UHF-Microphon MIPRO ACT-707D")
      p.model_links << ModelLink.create(:model => m, :quantity => 2)

      m = Model.find_by_name("Kopfhörer Sony MDR-CD780")
      p.model_links << ModelLink.create(:model => m, :quantity => 1)

      m = Model.find_by_name("Lichtstativ Alu Nigg 300cm")
      p.model_links << ModelLink.create(:model => m, :quantity => 1)

      
      c = Category.find_by_name("Anderes")
      add_to(c, p)
  end  
  
  

#  def create_some_users
#    params[:id].to_i.times do |i|
#      u = User.new(:login => "#{params[:name]}_#{i}")
#        r = Role.find(:first, :conditions => {:name => "manager"})
#        ips = InventoryPool.find(:all).select { rand(3) == 0 or i == 0 }
#        ips.each do |ip|
#          u.access_rights << AccessRight.new(:role => r, :inventory_pool => ip)
#        end
#      u.save
#    end
#  end

  def create_some_submitted_orders(quantity = 3)
    users = User.find(:all)
    quantity.times do |i|
      user = users[rand(users.size)]      
      order = Order.create(:user => user)
      3.times {
        d = Array.new
        2.times { d << Date.new(rand(2)+2008, rand(12)+1, rand(28)+1) }
        start_date = d.min 
        end_date = d.max
        model = user.models[rand(user.models.size)]
        order.add_line(rand(3)+1, model, order.user.id, start_date, end_date, model.inventory_pools.first ) if model
      }
      order.purpose = "This is the purpose: text text and more text, text text and more text, text text and more text, text text and more text."
      order.submit # TODO 03** make sure assignment to an inventory_pool
      puts "New order for inventory pool '#{order.inventory_pool}'"
    end
  end
  
    
  def create_meaningful_users
    users = ['Ramon Cahenzli', 'Jerome Müller', 'Franco Sellitto']
    users.each do |u|
      u = User.find_or_create_by_login(:login => u.to_s)
      unless u
        r = Role.find(:first, :conditions => {:name => "customer"})
        ips = InventoryPool.find(:all, :conditions => {:name => ["AVZ", "ITZ"]})
        ips.each do |ip|
          u.access_rights << AccessRight.new(:role => r, :inventory_pool => ip)
        end
        u.save
        puts "user #{u.login} created"
      end
    end
  end

#old#  
#  def create_meaningful_inventory
#    stuff = ['Beamer NEC LT 245', 'Beamer Davis 1650', 'Kamera Nikon D80', 'Stativ Manfrotto 390', 'Brillenputzuch', 'Laserschwert']
#
#    stuff.each do |st|
#      m = Model.new(:name => st )
#      m.save
#      2.times do |serial_nr|
#        i = Item.new(:model_id => m.id, :inventory_code => Item.get_new_unique_inventory_code )
#        i.save
#      end
#    end
#  end


  def create_some_root_categories
    video = Category.find_or_create_by_name(:name => 'Video')
    audio = Category.find_or_create_by_name(:name => 'Audio')
    computer = Category.find_or_create_by_name(:name => 'Computer')
    light = Category.find_or_create_by_name(:name => 'Licht')
    foto = Category.find_or_create_by_name(:name => 'Foto')
    other = Category.find_or_create_by_name(:name => 'Anderes')
    stative = Category.find_or_create_by_name(:name => 'Stative')
    
    add_to(video, Category.find_or_create_by_name(:name => 'Video Kamera'))
    add_to(video,  Category.find_or_create_by_name(:name => 'Film Kamera'))
    add_to(video,  Category.find_or_create_by_name(:name => 'Video Kamera Zubehör'))
    add_to(video,  Category.find_or_create_by_name(:name => 'Film Kamera Zubehör'))
    add_to(video,  Category.find_or_create_by_name(:name => 'Video Monitor'))
    add_to(video,  Category.find_or_create_by_name(:name => 'Video Recorder/Player'))
    add_to(video,  Category.find_or_create_by_name(:name => 'Stativ Video/Film/Foto'))
    
    add_to(audio,  Category.find_or_create_by_name(:name => 'Audio Recorder portable'))
    add_to(audio,  Category.find_or_create_by_name(:name => 'Audio Recorder/Player'))
    add_to(audio,  Category.find_or_create_by_name(:name => 'Kopfhörer'))
    add_to(audio,  Category.find_or_create_by_name(:name => 'Lautsprecher/-anlagen'))
    add_to(audio,  Category.find_or_create_by_name(:name => 'Mikrofon'))
    add_to(audio,  Category.find_or_create_by_name(:name => 'Mikrofon Zubehör'))
    add_to(audio,  Category.find_or_create_by_name(:name => 'Verschiedene AV Geräte'))
    add_to(audio,  Category.find_or_create_by_name(:name => 'Verstärker'))
    add_to(audio,  Category.find_or_create_by_name(:name => 'Mikrofon Zubehör'))

    add_to(foto,  Category.find_or_create_by_name(:name => 'Dia-/Hellraumprojektor'))
    add_to(foto,  Category.find_or_create_by_name(:name => 'Foto analog'))
    add_to(foto,  Category.find_or_create_by_name(:name => 'Foto digital'))
    add_to(foto,  Category.find_or_create_by_name(:name => 'Foto Zubehör'))
    add_to(foto,  Category.find_or_create_by_name(:name => 'Stativ Video/Film/Foto'))
    
    add_to(light,  Category.find_or_create_by_name(:name => 'Licht/Scheinwerfer'))
    add_to(light,  Category.find_or_create_by_name(:name => 'Licht Stative'))
    add_to(light,  Category.find_or_create_by_name(:name => 'Licht Zubehör'))
    add_to(light,  Category.find_or_create_by_name(:name => 'Elektro Material'))

    add_to(computer,  Category.find_or_create_by_name(:name => 'Desktop Macintosh'))
    add_to(computer,  Category.find_or_create_by_name(:name => 'Desktop PC'))
    add_to(computer,  Category.find_or_create_by_name(:name => 'Externer Massenspeicher'))
    add_to(computer,  Category.find_or_create_by_name(:name => 'IT-Display'))
    add_to(computer,  Category.find_or_create_by_name(:name => 'IT-Zubehör'))
    add_to(computer,  Category.find_or_create_by_name(:name => 'Notebook'))
    add_to(computer,  Category.find_or_create_by_name(:name => 'PowerBook'))
    add_to(computer,  Category.find_or_create_by_name(:name => 'Scanner/Lesegerät'))
    add_to(computer,  Category.find_or_create_by_name(:name => 'Server'))
    add_to(computer,  Category.find_or_create_by_name(:name => 'Netzwerkkomponente'))
    add_to(computer,  Category.find_or_create_by_name(:name => 'Andere Hardware'))

    add_to(other, Category.find_or_create_by_name(:name => 'DVD - Recorder/Player'))
    add_to(other, Category.find_or_create_by_name(:name => 'Medien-Rack/-Wagen'))
    add_to(other, Category.find_or_create_by_name(:name => 'Andere Hardware'))
    add_to(other, Category.find_or_create_by_name(:name => 'Leinwand'))
    add_to(other, Category.find_or_create_by_name(:name => 'Set-/Bühnenbau'))
    
    add_to(stative, Category.find_or_create_by_name(:name => 'Licht Stative'))
    add_to(stative, Category.find_or_create_by_name(:name => 'Stativ Video/Film/Foto'))
    
  end

  def add_to(parent, sub)
    parent.children << sub unless parent.children.include?(sub)
    sub.set_label(parent, sub.name)
  end

#  def create_some_categories
#    20.times do
#      chars = ("A".."Z").to_a
#      name = ""
#      1.upto(5) { |i| name << chars[rand(chars.size-1)] } 
#      Category.create(:name => name)
#    end
#    categories = Category.find(:all, :limit => rand(5)+3, :order => "RAND()")
#    categories.each do |c|
#      begin
##        c.children << Category.find(:all, :limit => rand(5)+3, :order => "RAND()", :conditions => ["id != ?", c.id])
#        (rand(5)+3).times do |i|
#          child = Category.find(:first, :order => "RAND()", :conditions => ["id != ?", c.id])
#          c.children << child
#          child.set_label(c, "#{child.name}_#{i}")
#        end
#        (rand(1)+1).times do |i|
##old#          
##          child = Package.find(:first, :order => "RAND()")
##          c.children << child
##          child.set_label(c, "#{child.name}_#{i}")
#
#          child = Template.find(:first, :order => "RAND()")
#          c.children << child
#          child.set_label(c, "#{child.name}_#{i}")
#        end
#      rescue
#      end
#    
#      m = Model.find(:first, :order => "RAND()")
#      c.model_links << ModelLink.create(:model => m, :quantity => 1)
#    end
#  end

  
  def create_some_properties
      chars_up = ("A".."Z").to_a
      chars_down = ("a".."z").to_a
      
      Model.all.each do |m|
        (rand(5)+1).times do
          key = ""
          value = ""
          1.upto(5) { |i| key << chars_up[rand(chars_up.size-1)] } 
          1.upto(5) { |i| value << chars_down[rand(chars_down.size-1)] } 
          m.properties << Property.create(:key => key, :value => value)
        end
      end
  end

  def create_some_compatibles
    Model.all.each do |m|
      begin
        m.compatibles << Model.find(:all, :limit => rand(5)+2, :order => "RAND()")
      rescue
      end
    end
  end

  def create_some_accessories
    a = ['Charger', 'Mouse', 'USB Cable', 'FireWire Cable', 'Memory Stick', 'Bag', 'Remote Controller']
    
    Model.all.each do |m|
      3.times do |i|
        m.accessories << Accessory.new(:name => a[rand(a.size)])
      end
    end
  end
  
#  def create_beautiful_order
#    m = Model.find(:first)
#  
#    
#    order = Order.new()
#    order.user_id = User.find_by_login("Ramon Cahenzli")
#    order.add_line(3, m, order.user_id, Date.new(2008, 10, 12), Date.new(2008, 10, 20))
#    order.purpose = "This is the purpose: text text and more text, text text and more text, text text and more text, text text and more text."
#    order.submit
#    
#    order = Order.new()
#    order.user_id = User.find_by_login("Ramon Cahenzli")
#    order.add_line(6, m, order.user_id, Date.new(2008, 10, 15), Date.new(2008, 10, 30))
#    order.purpose = "This is the purpose: text text and more text, text text and more text, text text and more text, text text and more text."
#    order.submit
#    
#    
#    order = Order.new()
#    order.user_id = User.find_by_login("Ramon Cahenzli")
#    order.add_line(1, m, order.user_id, Date.new(2008, 10, 20), Date.new(2008, 10, 30))
#    order.purpose = "This is the purpose: text text and more text, text text and more text, text text and more text, text text and more text."
#    order.submit
#    
#  end
    
#  def clean_db_and_index
#    Item.delete_all
#    Model.delete_all
#    Order.delete_all #destroy_all
#    OrderLine.delete_all
#    User.delete_all
#    Backup::Order.delete_all #destroy_all
#    Backup::OrderLine.delete_all
#    Contract.delete_all
#    ContractLine.delete_all
#    AccessRight.delete_all
#    ModelGroup.destroy_all
#    
#    FileUtils.remove_dir(File.dirname(__FILE__) + "/../../../index", true)
#  end
  
  
  
  
end