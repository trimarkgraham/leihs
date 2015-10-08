riot.tag('form-search', '<form class="row well" data-remote data-type="json"> <div class="col-sm-4"> <input autocomplete="false" autofocus class="form-control" name="search_term" onfocus="this.value = this.value;" onkeyup="{ keyUp }" placeholder="Search..." type="text"> </div> <div class="col-sm-8"></div> </form>', function(opts) {
    (function() {
      this.on('mount', function() {
        return this.submitForm();
      });
    
      this.keyUp = function(e) {
        if (e.target.value !== this.previous_search) {
          this.previous_search = e.target.value;
          clearTimeout(this.timer);
          return this.timer = setTimeout((function(_this) {
            return function() {
              return _this.submitForm();
            };
          })(this), 200);
        }
      };
    
      this.submitForm = function() {
        return $(this.root).find('form').submit();
      };
    
      $(document).on('ajax:success', 'form-search form', (function(_this) {
        return function(event, data, status, xhr) {
          return _this.parent.setData(data);
        };
      })(this));
    
    }).call(this);
  
});

riot.tag('suppliers-index', '<form-search></form-search> <div class="list-of-lines"> <div class="row" each="{ supplier in opts.suppliers }"> <div class="col-sm-6"> <strong>{ supplier.name }</strong> </div> <div class="col-sm-4"> {supplier.items_count} </div> <div class="col-sm-2 text-right line-actions"> <div class="btn-group" if="{ supplier.can_destroy }"> <a class="btn btn-default" href="/admin/suppliers/{supplier.id}/edit"> Edit </a> <button aria-expanded="false" aria-haspopup="true" class="btn btn-default dropdown-toggle" data-toggle="dropdown" type="button"> <i class="caret"></i> </button> <ul class="dropdown-menu"> <li class="bg-danger"> <a class="red" data-confirm="Are you sure you want to delete \'{supplier.name}\'?" data-method="delete" href="/admin/suppliers/{supplier.id}"> <i class="fa fa-trash"></i> Delete" </a> </li> </ul> </div> <a class="btn btn-default" href="/admin/suppliers/{supplier.id}/edit" if="{ !supplier.can_destroy }"> Edit </a> </div> </div> </div>', function(opts) {
    (function() {
      this.setData = function(data) {
        opts.suppliers = data;
        return this.update();
      };
    
    }).call(this);
  
});
