@SupplierIndex = React.createClass
  getInitialState: ()->
    {list: null}

  componentDidMount: ()->
    @submitForm()

  onInputChange: (event)->
    value = event.target.value
    if value != @state.previous_search
      @setState(previous_search: value)
      clearTimeout @timer
      @timer = setTimeout =>
        @submitForm()
      , 200

  submitForm = ->
    formNode = React.findDOMNode(@refs.SupplierSearchForm)
    $(formNode).submit()
    $(document).on 'ajax:success', 'form-search form', (event, data, status, xhr)=>
      @setState(list: data)

  render: ()->
    list = state.list or @props.list

    <div className='suppliers-index'>
      <SearchForm ref='SupplierSearchForm' onChange={onInputChange}/>
      <div className='list-of-lines'>
      {
        unless state.list
          <li>Not loaded yet…</li>
        else
          <SupplierItem supplier={item} key={item.id}/>
      }
      </div>
    </div>

@SupplierItem = React.createClass
  render: ()->
    supplier = @props.supplier
    
    <div className='row'>
      <div className='col-sm-6'>
        <strong>{supplier.name}</strong>
      </div>
      <div className='col-sm-4'>
        {supplier.items_count}
        {# TODO: _jed('%s items', supplier.items_count) }
      </div>
      <div className='col-sm-2'>
        {if supplier.can_destroy
          <div className='btn-group'>
            <a className='btn btn-default'
              href={"/admin/suppliers/#{supplier.id}/edit"}>
              Edit
              {# TODO: _('Edit')}
            </a>
            <button className'btn btn-default dropdown-toggle' type='button' data-toggle='dropdown' aria-haspopup='true' aria-expanded='false'>
              <i className='caret'/>
            </button>
            <ul className='dropdown-menu'>
              <li className'bg-danger'>
                <a className='red' href={'/admin/suppliers/{supplier.id}'} data={{method: :delete, confirm: "Are you sure you want to delete '#{supplier.name}'?"}}>
                  <i className='fa fa-trash'/>
                  Delete
                </a>
              </li>
            </ul>
          </div>
        else
          <a className='btn btn-default' href={"/admin/suppliers/#{supplier.id}/edit"}>
            Edit
          </a>
        }
      </div>
    </div>

@SearchForm = React.createClass
  propTypes:
    onChange: React.propTypes.function.isRequired
  render: ()->
    <form className='row well' data={{remote: true, type: 'json'}}>
      <div className='col-sm-4'>
        <input type='text' name='search_term' autofocus autocomplete={false}
          onChange={@props.onChange}/>
      </div>
    </form>
