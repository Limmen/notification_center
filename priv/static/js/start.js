var Start = React.createClass({
    render: function() {
        return (
            <div className="test">
            <h2>
            REACT WORLD
            </h2>
            </div>
        );
    }
});


React.render(
  <Start />,
  document.getElementById('react_container')
);
