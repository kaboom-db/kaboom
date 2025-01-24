// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from './application'

import CollectController from './actions/collect_controller'
import ChartController from './chart_controller'
import DialogController from './dialog_controller'
import ExpandAllController from './expand_all_controller'
import FavouriteController from './actions/favourite_controller'
import GenreSwiperController from './genre_swiper_controller'
import HorizontalStackChartController from './horizontal_stack_chart_controller'
import LocalTimeController from './local_time_controller'
import MessagesController from './messages_controller'
import ReadController from './actions/read_controller'
import ReadRangeController from './read_range_controller'
import RemoveItemController from './remove_item_controller'
import SearchController from './search_controller'
import StarRatingController from './star_rating_controller'
import SwiperController from './swiper_controller'
import WishlistController from './actions/wishlist_controller'

application.register('collect', CollectController)
application.register('chart', ChartController)
application.register('dialog', DialogController)
application.register('expand-all', ExpandAllController)
application.register('favourite', FavouriteController)
application.register('genre-swiper', GenreSwiperController)
application.register('horizontal-stack-chart', HorizontalStackChartController)
application.register('local-time', LocalTimeController)
application.register('messages', MessagesController)
application.register('read', ReadController)
application.register('read-range', ReadRangeController)
application.register('remove-item', RemoveItemController)
application.register('search', SearchController)
application.register('star-rating', StarRatingController)
application.register('swiper', SwiperController)
application.register('wishlist', WishlistController)
