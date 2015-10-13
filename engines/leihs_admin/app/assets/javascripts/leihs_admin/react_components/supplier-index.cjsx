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
    <SearchForm ref='SupplierSearchForm' onChange={onInputChange}/>
    unless state.list
      <div>Not loaded yet…</div>
    else
      <ul>
      {
        state.list.map (item)->
          <SupplierItem supplier={item} key={item.id}/>
      }
      </ul>

@SupplierItem = React.createClass
  render: ()->
    supplier = @props.supplier
    <li>
      {supplier.name}
    </li>

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
