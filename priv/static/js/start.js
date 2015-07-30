

var Notification = React.createClass({
    eventFired: false,
    
    getInitialState: function() { 
        return{
            hidden: true,
            seconds: new Date(this.props.date).getTime()/100,
        }
    },
    componentDidMount: function(){
        var id_div = "#" + this.props.nr;
        $(id_div).hide();
    }, 

    show: function(event){
        var id_div = "#" + this.props.nr;
        if(this.state.hidden){
            $(id_div).show();
            this.setState({hidden : false});
        }
        else{
            $(id_div).hide();
            this.setState({hidden : true});
        }
    },
    delete: function(event){
        event.stopPropagation()
        var Id = this.props.id;
        var that = this;
        $.post( "/index/delete",{Id : Id}, function( data ) {
            that.getNotifications();
        });        
    },
    getNotifications: function(){
        this.props.getNotifications();
    },
    highlight : function(){
        this.eventFired = true;
        var main_id_div = "#" + "main_" + this.props.nr + " .h4_title";
        var id_div = "#" + this.props.nr;
        $(main_id_div).append( $( "<span class='red'>active</span>" ) );
        setInterval(function(){
            $(main_id_div).fadeOut(300).fadeIn(300);
        });
    },
    
    render: function() {
        var id = "main_" + this.props.nr;
        var elapsed = Math.round(this.state.seconds - this.props.timeLeft/100);
        if(elapsed < 0){
            elapsed = 0;
            if(this.eventFired === false){
                this.highlight();
            }
        }
        // This will give a number with one digit after the decimal dot (xx.x):
        var seconds = (elapsed / 10).toFixed(1);    
        return(
        <div className="list-group-item" id={id} onClick={this.show}>
        <h4 className="h4_title">{this.props.title}
            <small> Time left: {seconds} </small> <span className="glyphicon glyphicon-remove delete" onClick={this.delete}></span>
            </h4>
            <div className="facts" id={this.props.nr}>
            <p><i>Description: {this.props.descr}</i></p>
            <p><i> Date: {this.props.date} </i></p>
            <p> <i>Song: {this.props.song} </i></p>
            </div>
        </div>
        );
    }
});

var Start = React.createClass({

    tick: function(){
//        this.setState({timer: new Date() - this.props.start});
        this.setState({timer: Date.now()});
    },

    dateT: function(){
        var that = this;
        $(function () {
            $('#datetimepicker2').datetimepicker({
                locale: 'sv',
            });
        });
    },

    getNotifications: function(){
        var that = this;
        $.get( "/index/notifications", function( data ) {
            if(data.hasOwnProperty('empty')){
                that.setState({notifications : []});
            }
            else{
                data.sort(function(a, b){
                    var res = new Date(a).getTime()/1000 - new Date(b).getTime()/1000
                    return res;
                })
                that.setState({notifications : data});   
            }
        });
    },
    getSongs: function(){
        var that = this;
        $.get( "/index/songs", function( data ) {
            that.setState({songs : data});
        });
    },
    componentDidMount: function(){
        this.timer = setInterval(this.tick, 50);
        this.dateT();
        this.getNotifications();
        this.getSongs();
        
        $("#success").hide();
        $("#fail").hide();        
    }, 
    success: function(){
        $("#success").show();        
        $('#success').delay(2000).fadeOut(400);
    },
    fail: function(){
        $("#fail").show();        
        $('#fail').delay(2000).fadeOut(400);
    },
    getInitialState: function() { 
        return{
            notifications : [],
            songs: [],
            timer: 0,
            inputDescr:"",
            inputDate: "",
            inputTitle:"",
            inputSongs:""
        };
    },
    validate: function(title, date){
        if(
            (typeof(title) !== "undefined" && title !== null && title !== "") &&
            (typeof(date) !== "undefined" && date !== null && date !== "")
        ){
            var diff = new Date(date).getTime()/1000 - Date.now()/1000;
            if(diff < 0 ){
                return false;
            }
            else{
                return true;   
            }
        }
        else{
            return false;
        }
        
    },
    newEvent: function(){
        var title = this.state.inputTitle;
        var descr = this.state.inputDescr;
        var dateTime = $("#datetimepicker2").find("input").val();
        var song = this.state.inputSongs;
        var bool = this.validate(title,dateTime);
        if(bool){
            this.success();
            var that = this;
            $.post( "/index/create",{title : title, description : descr, date: dateTime, song: song}, function( data ) {
                that.getNotifications();
            });
            this.setState({inputTitle : "", inputDescr : "", inputSongs : ""});
        }
        else{
            this.fail();
        }
        
    },
    descrChange: function(e){
        this.setState({inputDescr : e.target.value});
    },
    titleChange: function(e){
        this.setState({inputTitle : e.target.value});
    },
    songsChange: function(e){
        this.setState({inputSongs : e.target.value});
    },
    dateChange: function(e){
        this.setState({inputDate : e.target.value});
    },
    render: function() {
        return (
            <div>
            <div className="row">
            <div className="col-sm-3"></div>
            <div className="col-sm-6">
            <h1 className="align_center title">Notification Center</h1>
            </div>
            <div className="col-sm-3"></div>
            </div>
            <div className="row">
            <div className="col-sm-1"></div>
            <div className="col-sm-5">

            <h2> Add new event </h2>

            <div className="form-group">
            <label for="not_title">Title:</label>
            <input type="text" className="form-control" id="not_title" value={this.state.inputTitle} onChange={this.titleChange}/>
            </div>
            
            <div className="form-group">
            <label for="descr">Description:</label>
            <input type="text" className="form-control" id="descr" value={this.state.inputDescr} onChange={this.descrChange}/>
            </div>
            
            <div className="form-group">
            <label for="datetimepicker3">Date:</label>
            <div className='input-group date' id='datetimepicker2'>
            <input type='text' className="form-control" id="datetimepicker3" />
            <span className="input-group-addon">
            <span className="glyphicon glyphicon-calendar"></span>
            </span>
            </div>
            </div>
            <div className="form-group">
            <label for="songs">Song:</label>
            <select className="form-control" id="songs" value={this.state.inputSongs} onChange={this.songsChange}>
            <option> </option>
            {this.state.songs.map(function(song) {
                var name = song.name;
                var artist = song.artist;
                return <option>{name} - {artist}</option>
            }.bind(this))}
            </select>
            </div>            
            <button type="submit" className="btn btn-default" onClick={this.newEvent}>Submit</button>
            <div id="success" className="alert alert-success" role="alert"><strong>Event successfully saved</strong></div>
            <div id="fail" className="alert alert-danger" role="alert"><strong>Error, please check that you entered valid parameters. You can not set a date in the past</strong></div>
            </div>
            
            <div className="col-sm-5">
            <div className="list-group">
            <h2> Upcoming events </h2>
            {this.state.notifications.map(function(note, i) {
                var nr = "id-" + i;
                var id = note.id;
                var title = note.title;
                var descr = note.description;
                var date = note.date;
                var song = note.song;
                return <Notification nr={nr} id={id} title={title} descr={descr} date={date} song={song} timeLeft={this.state.timer} getNotifications={this.getNotifications}/>
            }.bind(this))}
            </div>
            </div>
            <div className="col-sm-1"></div>
            </div>
            </div>
        );
    }
});


React.render(
  <Start start={Date.now()}/>,
  document.getElementById('react_container')
);
