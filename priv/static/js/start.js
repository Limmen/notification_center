var Start = React.createClass({
    render: function() {
        var rawMarkup = marked("#MarkDown test.   ``console.log('code test');``");
        return (
            <div className="test">
            <span dangerouslySetInnerHTML={{__html: rawMarkup}} />
            </div>
        );
    }
});


React.render(
  <Start />,
  document.getElementById('react_container')
);
